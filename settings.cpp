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


#include "globals.h"
#include "gui/Slider.h"
#include "gui/ComboBox.h"

void InitGUI();

void UpdateSettings()
{
   Slider* partupdintslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("partupdintslider"));
   Slider* partcountslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("partcountslider"));
   Slider* viewdistslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("viewdistslider"));
   Slider* grassdensityslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("grassdensityslider"));
   Slider* grassdistslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("grassdistslider"));
   Slider* impdistslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("impdistslider"));
   Button* shadowsbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("shadowsbutton"));
   Button* softshadowsbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("softshadowsbutton"));
   Button* reflectionbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("reflectionbutton"));
   Button* fullscreenbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("fullscreenbutton"));
   ComboBox* resolutionbox = dynamic_cast<ComboBox*>(gui[settings]->GetWidget("resolutionbox"));
   Slider* turnsmoothslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("turnsmoothslider"));
   Slider* mousespeedslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("mousespeedslider"));
   Slider* weaponfocusslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("weaponfocusslider"));
   ComboBox* aabox = dynamic_cast<ComboBox*>(gui[settings]->GetWidget("aabox"));
   ComboBox* afbox = dynamic_cast<ComboBox*>(gui[settings]->GetWidget("afbox"));
   LineEdit* nameedit = dynamic_cast<LineEdit*>(gui[settings]->GetWidget("nameedit"));
   Slider* musicvolslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("musicvolslider"));
   GUI* forwardbutton = gui[settings]->GetWidget("forwardbutton");
   GUI* backbutton = gui[settings]->GetWidget("backbutton");
   GUI* leftbutton = gui[settings]->GetWidget("leftbutton");
   GUI* rightbutton = gui[settings]->GetWidget("rightbutton");
   GUI* loadoutbutton = gui[settings]->GetWidget("loadoutbutton");
   GUI* useitembutton = gui[settings]->GetWidget("useitembutton");
   
   partupdintslider->value = console.GetInt("partupdint");
   partcountslider->value = 0;//console.GetInt("partcount");
   viewdistslider->value = console.GetInt("viewdist");
   grassdensityslider->value = int(console.GetFloat("grassdensity") * 100);
   grassdistslider->value = console.GetInt("grassdrawdist");
   impdistslider->value = console.GetInt("impdistmulti");
   shadowsbutton->togglestate = console.GetBool("shadows") ? 1 : 0;
   softshadowsbutton->togglestate = console.GetBool("softshadows") ? 1 : 0;
   reflectionbutton->togglestate = console.GetBool("reflection") ? 1 : 0;
   fullscreenbutton->togglestate = console.GetBool("fullscreen") ? 1 : 0;
   turnsmoothslider->value = console.GetInt("turnsmooth");
   mousespeedslider->value = console.GetInt("mousespeed");
   weaponfocusslider->value = console.GetInt("weaponfocus");
   nameedit->text = console.GetString("name");
   musicvolslider->value = console.GetInt("musicvol");
   forwardbutton->text = SDL_GetKeyName(keys.keyforward);
   backbutton->text = SDL_GetKeyName(keys.keyback);
   leftbutton->text = SDL_GetKeyName(keys.keyleft);
   rightbutton->text = SDL_GetKeyName(keys.keyright);
   loadoutbutton->text = SDL_GetKeyName(keys.keyloadout);
   useitembutton->text = SDL_GetKeyName(keys.keyuseitem);
   
   // Set boxes to current aa/af settings
   int aa = console.GetInt("aa");
   if (aa == 0)
      aabox->Select(0);
   else if (aa == 2)
      aabox->Select(1);
   else if (aa == 4)
      aabox->Select(2);
   else if (aa == 8)
      aabox->Select(3);
   else if (aa == 16)
      aabox->Select(4);
   int af = console.GetInt("af");
   if (af == 1)
      afbox->Select(0);
   else if (af == 2)
      afbox->Select(1);
   else if (af == 4)
      afbox->Select(2);
   else if (af == 8)
      afbox->Select(3);
   else if (af == 16)
      afbox->Select(4);
   
   // List available resolutions
   Uint32 flags = SDL_OPENGL | SDL_FULLSCREEN;
   SDL_Rect** modes = SDL_ListModes(NULL, flags);
   bool found = false;
   int i;
   for (i = 0; modes[i]; ++i)
   {
      resolutionbox->Add(ToString(modes[i]->w) + " x " + ToString(modes[i]->h));
      if (modes[i]->w == console.GetInt("screenwidth") &&
          modes[i]->h == console.GetInt("screenheight"))
      {
         resolutionbox->Select(i);
         found = true;
      }
   }
   if (!found)
   {
      resolutionbox->Add(console.GetString("screenwidth") + " x " + console.GetString("screenheight"));
      resolutionbox->Select(i);
   }
}


void SaveSettings()
{
   Slider* partupdintslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("partupdintslider"));
   Slider* partcountslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("partcountslider"));
   Slider* viewdistslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("viewdistslider"));
   Slider* grassdensityslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("grassdensityslider"));
   Slider* grassdistslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("grassdistslider"));
   Slider* impdistslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("impdistslider"));
   Button* shadowsbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("shadowsbutton"));
   Button* softshadowsbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("softshadowsbutton"));
   Button* reflectionbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("reflectionbutton"));
   Button* fullscreenbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("fullscreenbutton"));
   ComboBox* resolutionbox = dynamic_cast<ComboBox*>(gui[settings]->GetWidget("resolutionbox"));
   Slider* turnsmoothslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("turnsmoothslider"));
   Slider* mousespeedslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("mousespeedslider"));
   Slider* weaponfocusslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("weaponfocusslider"));
   ComboBox* aabox = dynamic_cast<ComboBox*>(gui[settings]->GetWidget("aabox"));
   ComboBox* afbox = dynamic_cast<ComboBox*>(gui[settings]->GetWidget("afbox"));
   LineEdit* nameedit = dynamic_cast<LineEdit*>(gui[settings]->GetWidget("nameedit"));
   Slider* musicvolslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("musicvolslider"));
   
   bool dorestart = false;
   
   console.Parse("setsave partupdint " + ToString(partupdintslider->value), false);
   // Not implemented yet
   //console.Parse("set partcount " + ToString(partcountslider->value), false);
   console.Parse("setsave viewdist " + ToString(viewdistslider->value), false);
   console.Parse("setsave grassdensity " + ToString(float(grassdensityslider->value) / 100.f), false);
   console.Parse("setsave grassdrawdist " + ToString(grassdistslider->value), false);
   console.Parse("setsave impdistmulti " + ToString(impdistslider->value), false);
   console.Parse("setsave shadows " + ToString(shadowsbutton->togglestate), false);
   console.Parse("setsave softshadows " + ToString(softshadowsbutton->togglestate), false);
   console.Parse("setsave reflection " + ToString(reflectionbutton->togglestate), false);
   if (bool(fullscreenbutton->togglestate) != console.GetBool("fullscreen"))
      dorestart = true;
   console.Parse("setsave fullscreen " + ToString(fullscreenbutton->togglestate), false);
   console.Parse("setsave turnsmooth " + ToString(turnsmoothslider->value), false);
   console.Parse("setsave mousespeed " + ToString(mousespeedslider->value), false);
   console.Parse("setsave weaponfocus " + ToString(weaponfocusslider->value), false);
   console.Parse("setsave aa " + ToString(aabox->SelectedText()), false);
   console.Parse("setsave af " + ToString(afbox->SelectedText()), false);
   console.Parse("setsave name " + nameedit->text, false);
   console.Parse("setsave musicvol " + ToString(musicvolslider->value), false);
   StartBGMusic();
   
   stringstream selectedres(resolutionbox->SelectedText());
   int newwidth, newheight;
   selectedres >> newwidth;
   selectedres.ignore();
   selectedres.ignore();
   selectedres >> newheight;
   if (newwidth != console.GetInt("screenwidth") || newheight != console.GetInt("screenheight"))
      dorestart = true;
   console.Parse("setsave screenwidth " + ToString(newwidth), false);
   console.Parse("setsave screenheight " + ToString(newheight), false);
   
   // Write keys file
   ofstream writekeys("keys.cfg", std::ios_base::out);
   writekeys << "# Do not edit this file - it will be overwritten\n";
   writekeys << "set keyforward " << keys.keyforward << endl;
   writekeys << "set keyback " << keys.keyback << endl;
   writekeys << "set keyleft " << keys.keyleft << endl;
   writekeys << "set keyright " << keys.keyright << endl;
   writekeys << "set keyloadout " << keys.keyloadout << endl;
   writekeys << "set keyuseitem " << keys.keyuseitem << endl;
   writekeys << "set mousefire " << (int)keys.mousefire << endl;
   writekeys << "set mousezoom " << (int)keys.mousezoom << endl;
   writekeys << "set mouseuse " << (int)keys.mouseuse << endl;
   writekeys << "set mousenextweap " << (int)keys.mousenextweap << endl;
   writekeys << "set mouseprevweap " << (int)keys.mouseprevweap << endl;
   writekeys.close();
   
   if (dorestart)
   {
      console.Parse("restartgl");
      reloadgui = true;
   }
}
