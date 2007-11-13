// Actions for the GUI class to use
#include "GUI.h"
#include "ProgressBar.h"
#include "ServerInfo.h"
#include "Table.h"
#include "ComboBox.h"
#include "PlayerData.h"
#include "types.h"

extern GUI mainmenu, loadprogress, loadoutmenu;
extern vector<ServerInfo> servers;
extern bool spawnrequest;
extern vector<PlayerData> player;
extern SDL_mutex* clientmutex;

void GetMap(string);
void Repaint();
void ConsoleHandler(string);

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
}


void Spawn()
{
   spawnrequest = true;
   loadoutmenu.visible = false;
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
