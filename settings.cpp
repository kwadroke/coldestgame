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
   Button* reflectionbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("reflectionbutton"));
   Button* fullscreenbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("fullscreenbutton"));
   ComboBox* resolutionbox = dynamic_cast<ComboBox*>(gui[settings]->GetWidget("resolutionbox"));
   Slider* turnsmoothslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("turnsmoothslider"));
   Slider* mousespeedslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("mousespeedslider"));
   Slider* weaponfocusslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("weaponfocusslider"));
   
   partupdintslider->value = console.GetInt("partupdint");
   partcountslider->value = 0;//console.GetInt("partcount");
   viewdistslider->value = console.GetInt("viewdist");
   grassdensityslider->value = console.GetInt("grassdensity");
   grassdistslider->value = console.GetInt("grassdist");
   impdistslider->value = console.GetInt("impdistmulti");
   shadowsbutton->togglestate = console.GetBool("shadows") ? 1 : 0;
   reflectionbutton->togglestate = console.GetBool("reflection") ? 1 : 0;
   fullscreenbutton->togglestate = console.GetBool("fullscreen") ? 1 : 0;
   turnsmoothslider->value = console.GetInt("turnsmooth");
   mousespeedslider->value = console.GetInt("mousespeed");
   weaponfocusslider->value = console.GetInt("weaponfocus");
   
   // List available resolutions
   Uint32 flags = SDL_OPENGL | SDL_FULLSCREEN;
   SDL_Rect** modes = SDL_ListModes(NULL, flags);
   for (int i = 0; modes[i]; ++i)
   {
      resolutionbox->Add(ToString(modes[i]->w) + " x " + ToString(modes[i]->h));
      if (modes[i]->w == console.GetInt("screenwidth") &&
          modes[i]->h == console.GetInt("screenheight"))
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
   Button* reflectionbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("reflectionbutton"));
   Button* fullscreenbutton = dynamic_cast<Button*>(gui[settings]->GetWidget("fullscreenbutton"));
   ComboBox* resolutionbox = dynamic_cast<ComboBox*>(gui[settings]->GetWidget("resolutionbox"));
   Slider* turnsmoothslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("turnsmoothslider"));
   Slider* mousespeedslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("mousespeedslider"));
   Slider* weaponfocusslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("weaponfocusslider"));
   
   console.Parse("setsave partupdint " + ToString(partupdintslider->value), false);
   // Not implemented yet
   //console.Parse("set partcount " + ToString(partcountslider->value), false);
   console.Parse("setsave viewdist " + ToString(viewdistslider->value), false);
   console.Parse("setsave grassdensity " + ToString(float(grassdensityslider->value) / 100.f), false);
   console.Parse("setsave grassdist " + ToString(grassdistslider->value), false);
   console.Parse("setsave impdistmulti " + ToString(impdistslider->value), false);
   console.Parse("setsave shadows " + ToString(shadowsbutton->togglestate), false);
   console.Parse("setsave reflection " + ToString(reflectionbutton->togglestate), false);
   console.Parse("setsave fullscreen " + ToString(fullscreenbutton->togglestate), false);
   console.Parse("setsave turnsmooth " + ToString(turnsmoothslider->value), false);
   console.Parse("setsave mousespeed " + ToString(mousespeedslider->value), false);
   console.Parse("setsave weaponfocus " + ToString(weaponfocusslider->value), false);
   
   stringstream selectedres(resolutionbox->SelectedText());
   int newwidth, newheight;
   selectedres >> newwidth;
   selectedres.ignore();
   selectedres.ignore();
   selectedres >> newheight;
   bool dorestart = false;
   if (newwidth != console.GetInt("screenwidth") || newheight != console.GetInt("screenheight"))
      dorestart = true;
   console.Parse("setsave screenwidth " + ToString(newwidth), false);
   console.Parse("setsave screenheight " + ToString(newheight), false);
   
   if (dorestart)
   {
      console.Parse("restartgl");
      //InitGUI(); // Can't call this here right now:-(
   }
}
