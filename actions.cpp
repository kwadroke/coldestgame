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
#include "netdefs.h"
#include "renderdefs.h"
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
   
   SDL_mutexP(clientmutex);
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
   GUI* salvagebox = gui[loadoutmenu]->GetWidget("Salvage");
   weightbox->text = ToString(totalweight) + "/" + ToString(maxweight) + " tons";
   int sweight = CalculatePlayerWeight(player[0]);
   salvagebox->text = ToString(player[0].salvage - sweight) + " tons";
   if (totalweight > maxweight || sweight > player[0].salvage)
      spawnbutton->visible = false;
   else spawnbutton->visible = true;
   SDL_mutexV(clientmutex);
}


void Connect()
{
   Table* servlist = (Table*)gui[mainmenu]->GetWidget("serverlist");
   vector<ServerInfo>::iterator i;
   string serveraddress;
   Uint16 serverport;
   int currsel = servlist->Selected();
   if (currsel == -1) return;
   int counter = 0;
   SDL_mutexP(clientmutex);
   for (i = servers.begin(); i != servers.end(); ++i)
   {
      if (counter == currsel)
      {
         serveraddress = i->strip;
         serverport = SDLNet_Read16(&i->address.port);
         break;
      }
      ++counter;
   }
   SDL_mutexV(clientmutex);
   console.Parse("set serveraddr " + serveraddress, false);
   console.Parse("set serverport " + ToString(serverport), false);
   console.Parse("connect");
   UpdateUnitSelection();
}


void ConnectToIp()
{
   GUI* servname = gui[mainmenu]->GetWidget("servername");
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
   server = true;
   serverthread = SDL_CreateThread(Server, NULL);
   console.Parse("set serveraddr localhost", false);
   console.Parse("connect", false);
   UpdateUnitSelection();
}


void Resume()
{
   ShowGUI(loadoutmenu);
}


void LoadoutToMain()
{
   ShowGUI(mainmenu);
}


void Spawn()
{
   SDL_mutexP(clientmutex);
   if (player[servplayernum].spawned)
   {
      gui[loadoutmenu]->visible = false;
      gui[hud]->visible = true;
   }
   else
   {
      spawnrequest = true;
   }
   SDL_mutexV(clientmutex);
}


void SubmitCommand()
{
   cout << "Submitting command" << endl;
   LineEdit* currcommand = (LineEdit*)gui[consolegui]->GetWidget("consoleinput");
   TextArea* consoleout = (TextArea*)gui[consolegui]->GetWidget("consoleoutput");
   console.Parse(currcommand->text);
   consoleout->Append(currcommand->text + '\n');
   currcommand->text = "";
   gui[consolegui]->visible = false;
}


void SelectTeam(int team)
{
   changeteam = team;
}


void ShowMain()
{
   ShowGUI(mainmenu);
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
   else if (action == "resume")
      Resume();
   else if (action == "spawn")
      Spawn();
   else if (action == "loadouttomain")
      LoadoutToMain();
   else if (action == "updateunitselection")
      UpdateUnitSelection();
   else if (action == "submitcommand")
      SubmitCommand();
   else if (action == "selectteam1")
      SelectTeam(1);
   else if (action == "selectteam2")
      SelectTeam(2);
   else if (action == "showmain")
      ShowMain();
   else if (action == "showsettings")
      ShowSettings();
   else if (action == "savesettings")
      SaveSettings();
   else if (action == "selectspawn")
      SelectSpawn();
   else if (action != "")
      cout << "Warning: Attempted to do undefined action " << action << endl;
}
