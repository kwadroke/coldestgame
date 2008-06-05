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
   ShowGUI(loadoutmenu);
}


void ConnectToIp()
{
   GUI* servname = gui[mainmenu]->GetWidget("servername");
   console.Parse("set serveraddr " + servname->text);
   console.Parse("connect");
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
}
