// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2011 Ben Nemec
// @End License@


// Actions for the GUI class to use
#include "gui/GUI.h"
#include "gui/ProgressBar.h"
#include "ServerInfo.h"
#include "gui/Table.h"
#include "gui/ComboBox.h"
#include "gui/TextArea.h"
#include "PlayerData.h"
#include "types.h"
#include "globals.h"
#include "renderdefs.h"
#include "editor.h" // Editor actions are defined here
#include <boost/tokenizer.hpp>

using boost::tokenizer;
using boost::char_separator;

void ConsoleHandler(string);
void Quit();

void UpdateUnitSelection()
{
   ComboBox* unitbox = (ComboBox*)gui[loadoutmenu]->GetWidget("Unit");
   ComboBox* torsobox = (ComboBox*)gui[loadoutmenu]->GetWidget("Torso");
   ComboBox* larmbox = (ComboBox*)gui[loadoutmenu]->GetWidget("Left Arm");
   ComboBox* rarmbox = (ComboBox*)gui[loadoutmenu]->GetWidget("Right Arm");
   ComboBox* itembox = (ComboBox*)gui[loadoutmenu]->GetWidget("Item");
   
   player[0].unit = unitbox->Selected();
   int weapid;
   weapid = torsobox->Selected();
   if (weapid >= 0 && weapid < Weapon::numweapons)
      player[0].weapons[Torso] = Weapon(weapid);
   weapid = larmbox->Selected();
   if (weapid >= 0 && weapid < Weapon::numweapons)
      player[0].weapons[LArm] = Weapon(weapid);
   weapid = rarmbox->Selected();
   if (weapid >= 0 && weapid < Weapon::numweapons)
      player[0].weapons[RArm] = Weapon(weapid);
   int itemtype;
   itemtype = itembox->Selected();
   if (itemtype >= 0 && itemtype < Item::numitems)
      player[0].item = Item(itemtype, meshes);
   
   for (size_t i = 0; i < numbodyparts; ++i)
      player[0].weapons[i].ammo = int(float(player[0].weapons[i].ammo) * player[0].item.AmmoMult());
   
   // Calculate weight
   int maxweight = units[player[0].unit].weight;
   int totalweight = 0;
   for (size_t i = 0; i < numbodyparts; ++i)
      totalweight += player[0].weapons[i].Weight();
   totalweight += player[0].item.Weight();
   GUI* weightbox = gui[loadoutmenu]->GetWidget("Weight");
   GUI* spawnbutton = gui[loadoutmenu]->GetWidget("Spawn");
   ComboBox* spawnbox = dynamic_cast<ComboBox*>(gui[loadoutmenu]->GetWidget("SpawnPoints"));
   GUI* salvagebox = gui[loadoutmenu]->GetWidget("Salvage");
   weightbox->text = ToString(totalweight) + "/" + ToString(maxweight) + " tons";
   int sweight = CalculatePlayerWeight(player[0]);
   salvagebox->text = ToString(player[0].salvage - sweight) + " tons";
   if (totalweight > maxweight || sweight > player[0].salvage || spawnbox->Selected() == -1)
      spawnbutton->visible = false;
   else spawnbutton->visible = true;
}


void Connect()
{
   Table* servlist = (Table*)gui[serverbrowser]->GetWidget("serverlist");
   vector<ServerInfo>::iterator i;
   string serveraddress;
   Uint16 serverport = 12010;
   int currsel = servlist->Selected();
   if (currsel == -1) return;
   int counter = 0;
   for (i = netcode->servers.begin(); i != netcode->servers.end(); ++i)
   {
      if (i->inlist)
      {
         if (counter == currsel)
         {
            serveraddress = i->strip;
            serverport = SDLNet_Read16(&i->address.port);
            break;
         }
         ++counter;
      }
   }
   console.Parse("set serveraddr " + serveraddress, false);
   console.Parse("set serverport " + ToString(serverport), false);
   console.Parse("connect");
   UpdateUnitSelection();
}


void ConnectToIp()
{
   GUI* servname = gui[serverbrowser]->GetWidget("servername");
   string wholeaddr = servname->text;
   string serveraddr, serverport = "12010";
   if (wholeaddr.find(":") != string::npos)
   {
      char_separator<char> sep(":");
      tokenizer<char_separator<char> > tok(wholeaddr, sep);
      tokenizer<char_separator<char> >::iterator i = tok.begin();
      serveraddr = *i;
      ++i;
      serverport = *i;
   }
   else
   {
      serveraddr = wholeaddr;
   }
   console.Parse("set serveraddr " + serveraddr, false);
   console.Parse("set serverport " + serverport, false);
   console.Parse("connect");
   UpdateUnitSelection();
}


void Host()
{
   if (server) // Starting two servers == BAD
      return;
   server = true;
   serverthread = SDL_CreateThread(Server, NULL);
   console.Parse("set serveraddr localhost", false);
   console.Parse("connect", false);
   UpdateUnitSelection();
}


void Join()
{
   ShowGUI(serverbrowser);
}


void Resume()
{
   if (player[servplayernum].spawned)
      ShowGUI(hud);
   else
      ShowGUI(loadoutmenu);
}


void Spawn()
{
   if (player[servplayernum].spawned)
   {
      gui[loadoutmenu]->visible = false;
      gui[hud]->visible = true;
   }
   else
   {
      netcode->SpawnRequest();
   }
}


void SubmitCommand()
{
   logout << "Submitting command" << endl;
   LineEdit* currcommand = (LineEdit*)gui[consolegui]->GetWidget("consoleinput");
   TextArea* consoleout = (TextArea*)gui[consolegui]->GetWidget("consoleoutput");
   console.Parse(currcommand->text);
   consoleout->Append(currcommand->text + '\n');
   currcommand->text = "";
   gui[consolegui]->visible = false;
}


void SelectTeam(int team)
{
   netcode->ChangeTeam(team);
   player[0].spectate = false;
}


void Spectate()
{
   player[0].spectate = true;
   netcode->ChangeTeam(0);
   spectateplayer = 0;
   SpectateNext();
}


void ShowMain()
{
   ShowGUI(mainmenu);
}

void ShowCredits()
{
   ShowGUI(credits);
}

void ShowSettings()
{
   UpdateSettings();
   ShowGUI(settings);
}


void SelectSpawn()
{
   for (size_t i = 0; i < spawnbuttons.size(); ++i)
   {
      Button* current = dynamic_cast<Button*>(spawnbuttons[i].get());
      if (current->togglestate)
      {
         ComboBox *spawnpointsbox = dynamic_cast<ComboBox*>(gui[loadoutmenu]->GetWidget("SpawnPoints"));
         spawnpointsbox->Select(i);
         current->togglestate = 0;
      }
   }
}


void RefreshServers()
{
   Table* serverlist = (Table*)gui[serverbrowser]->GetWidget("serverlist");
   vector<ServerInfo>::iterator i;
   if (!serverlist)
   {
      logout << "Failed to get pointer to serverlist" << endl;
      exit(-10);
   }
   serverlist->Clear();
   for (i = netcode->servers.begin(); i != netcode->servers.end(); ++i)
   {
      i->inlist = false;
   }
}


void DoBind(SDLKey& key)
{
   GUI* message = gui[settings]->GetWidget("bindmessage");
   message->visible = true;
   SDL_Event event;
   while (!SDL_PollEvent(&event) || event.type != SDL_KEYDOWN){Repaint();}

   if (event.type == SDL_KEYDOWN && event.key.keysym.sym != SDLK_ESCAPE)
      key = event.key.keysym.sym;

   message->visible = false;
   
   GUI* forwardbutton = gui[settings]->GetWidget("forwardbutton");
   GUI* backbutton = gui[settings]->GetWidget("backbutton");
   GUI* leftbutton = gui[settings]->GetWidget("leftbutton");
   GUI* rightbutton = gui[settings]->GetWidget("rightbutton");
   GUI* loadoutbutton = gui[settings]->GetWidget("loadoutbutton");
   GUI* useitembutton = gui[settings]->GetWidget("useitembutton");
   forwardbutton->text = SDL_GetKeyName(keys.keyforward);
   backbutton->text = SDL_GetKeyName(keys.keyback);
   leftbutton->text = SDL_GetKeyName(keys.keyleft);
   rightbutton->text = SDL_GetKeyName(keys.keyright);
   loadoutbutton->text = SDL_GetKeyName(keys.keyloadout);
   useitembutton->text = SDL_GetKeyName(keys.keyuseitem);
}

void BindForward()
{
   DoBind(keys.keyforward);
}

void BindBack()
{
   DoBind(keys.keyback);
}

void BindLeft()
{
   DoBind(keys.keyleft);
}

void BindRight()
{
   DoBind(keys.keyright);
}

void BindLoadout()
{
   DoBind(keys.keyloadout);
}

void BindUseItem()
{
   DoBind(keys.keyuseitem);
}


// Stick this outside of GUI so we don't have to update the class every time we add an action
void Action(const string& action)
{
   if (action == "exit")
      Quit();
   else if (action == "connect")
      Connect();
   else if (action == "connectip")
      ConnectToIp();
   else if (action == "host")
      Host();
   else if (action == "join")
      Join();
   else if (action == "resume")
      Resume();
   else if (action == "spawn")
      Spawn();
   else if (action == "updateunitselection")
      UpdateUnitSelection();
   else if (action == "submitcommand")
      SubmitCommand();
   else if (action == "selectteam1")
      SelectTeam(1);
   else if (action == "selectteam2")
      SelectTeam(2);
   else if (action == "spectate")
      Spectate();
   else if (action == "showmain")
      ShowMain();
   else if (action == "showcredits")
      ShowCredits();
   else if (action == "showsettings")
      ShowSettings();
   else if (action == "savesettings")
      SaveSettings();
   else if (action == "selectspawn")
      SelectSpawn();
   else if (action == "saveobject")
      SaveObject();
   else if (action == "addobject")
      AddObject();
   else if (action == "addtree")
      AddTree();
   else if (action == "deleteobject")
      DeleteObject();
   else if (action == "savemap")
      SaveMap();
   else if (action == "randomseed")
      RandomizeSeed();
   else if (action == "bindforward")
      BindForward();
   else if (action == "bindback")
      BindBack();
   else if (action == "bindleft")
      BindLeft();
   else if (action == "bindright")
      BindRight();
   else if (action == "bindloadout")
      BindLoadout();
   else if (action == "binduseitem")
      BindUseItem();
   else if (action == "refreshservers")
      RefreshServers();
   else if (action != "")
      logout << "Warning: Attempted to do undefined action " << action << endl;
}
