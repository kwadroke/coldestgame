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
   Table* servlist = (Table*)mainmenu.GetWidget("serverlist");
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
   ConsoleHandler("set serveraddr " + serveraddress);
   ConsoleHandler("connect");
   mainmenu.visible = false;
   loadoutmenu.visible = true;
}


void ConnectToIp()
{
   GUI* servname = mainmenu.GetWidget("servername");
   ConsoleHandler("set serveraddr " + servname->text);
   ConsoleHandler("connect");
   mainmenu.visible = false;
   loadoutmenu.visible = true;
}


void Host()
{
   server = true;
   serverthread = SDL_CreateThread(Server, NULL);
   ConsoleHandler("set serveraddr localhost");
   ConsoleHandler("connect");
   mainmenu.visible = false;
   loadoutmenu.visible = true;
}


void TestAction()
{
   GUI* temp = loadprogress.GetWidget("loadingprogress");
   temp->visible = true;
   ProgressBar* temp1 = (ProgressBar*)loadprogress.GetWidget("loadprogressbar");
   temp1->value = 50;
}


void Resume()
{
   mainmenu.visible = false;
   hud.visible = true;
}


void Spawn()
{
   spawnrequest = true;
}


void LoadoutToMain()
{
   loadoutmenu.visible = false;
   mainmenu.visible = true;
}


void UpdateUnitSelection()
{
   ComboBox* unitbox = (ComboBox*)loadoutmenu.GetWidget("Unit");
   ComboBox* torsobox = (ComboBox*)loadoutmenu.GetWidget("Torso");
   ComboBox* larmbox = (ComboBox*)loadoutmenu.GetWidget("Left Arm");
   ComboBox* rarmbox = (ComboBox*)loadoutmenu.GetWidget("Right Arm");
   ComboBox* itembox = (ComboBox*)loadoutmenu.GetWidget("Item");
   
   player[0].unit = unitbox->Selected();
   player[0].weapons[Torso] = torsobox->Selected();
   if (player[0].weapons[Torso] < 0 || player[0].weapons[Torso] > numweapons)
      player[0].weapons[Torso] = 0;
   player[0].weapons[LArm] = larmbox->Selected();
   if (player[0].weapons[LArm] < 0 || player[0].weapons[LArm] > numweapons)
      player[0].weapons[LArm] = 0;
   player[0].weapons[RArm] = rarmbox->Selected();
   if (player[0].weapons[RArm] < 0 || player[0].weapons[RArm] > numweapons)
      player[0].weapons[RArm] = 0;
}


void SubmitCommand()
{
   cout << "Submitting command" << endl;
   LineEdit* currcommand = (LineEdit*)console.GetWidget("consoleinput");
   TextArea* consoleout = (TextArea*)console.GetWidget("consoleoutput");
   ConsoleHandler(currcommand->text);
   consoleout->Append(currcommand->text + '\n');
   currcommand->text = "";
   console.visible = false;
}


void RequestNewTeam()
{
   ComboBox *teamselect = (ComboBox*)loadoutmenu.GetWidget("TeamSelect");
   changeteam = teamselect->Selected() + 1;
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
}
