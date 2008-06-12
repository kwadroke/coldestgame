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
   if (totalweight > maxweight &&  sweight > player[0].salvage)
      spawnbutton->visible = false;
   else spawnbutton->visible = true;
   SDL_mutexV(clientmutex);
}


void Connect()
{
   Table* servlist = (Table*)gui[mainmenu]->GetWidget("serverlist");
   vector<ServerInfo>::iterator i;
   string serveraddress;
   int currsel = servlist->Selected();
   if (currsel == -1) return;
   int counter = 0;
   SDL_mutexP(clientmutex);
   for (i = servers.begin(); i != servers.end(); ++i)
   {
      if (counter == currsel)
      {
         serveraddress = i->strip;
         break;
      }
      ++counter;
   }
   SDL_mutexV(clientmutex);
   console.Parse("set serveraddr " + serveraddress);
   console.Parse("connect");
   UpdateUnitSelection();
   ShowGUI(loadoutmenu);
}


void ConnectToIp()
{
   GUI* servname = gui[mainmenu]->GetWidget("servername");
   console.Parse("set serveraddr " + servname->text);
   console.Parse("connect");
   UpdateUnitSelection();
   ShowGUI(loadoutmenu);
}


void Host()
{
   server = true;
   serverthread = SDL_CreateThread(Server, NULL);
   console.Parse("set serveraddr localhost");
   console.Parse("connect");
   ComboBox *teamselect = (ComboBox*)gui[loadoutmenu]->GetWidget("TeamSelect");
   teamselect->Select(1);
   UpdateUnitSelection();
   ShowGUI(loadoutmenu);
}


void TestAction()
{
   GUI* temp = gui[loadprogress]->GetWidget("loadingprogress");
   temp->visible = true;
   ProgressBar* temp1 = (ProgressBar*)gui[loadprogress]->GetWidget("loadprogressbar");
   temp1->value = 50;
}


void Resume()
{
   gui[mainmenu]->visible = false;
   gui[hud]->visible = true;
}


void LoadoutToMain()
{
   ShowGUI(mainmenu);
}


void Spawn()
{
   spawnrequest = true;
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


void RequestNewTeam()
{
   ComboBox *teamselect = (ComboBox*)gui[loadoutmenu]->GetWidget("TeamSelect");
   changeteam = teamselect->Selected() + 1;
}


void ShowMain()
{
   ShowGUI(mainmenu);
}

void ShowSettings()
{
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
   else if (action == "showprogress")
      TestAction();
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
   else if (action == "requestnewteam")
      RequestNewTeam();
   else if (action == "showmain")
      ShowMain();
   else if (action == "showsettings")
      ShowSettings();
   else if (action == "selectspawn")
      SelectSpawn();
   else if (action != "")
      cout << "Warning: Attempted to do undefined action " << action << endl;
}
