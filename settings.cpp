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
   
   partupdintslider->value = console.GetInt("partupdint");
   partcountslider->value = 0;//console.GetInt("partcount");
   viewdistslider->value = console.GetInt("viewdist");
   grassdensityslider->value = console.GetInt("grassdensity");
   grassdistslider->value = console.GetInt("grassdist");
   impdistslider->value = console.GetInt("impdistmulti");
   shadowsbutton->togglestate = console.GetBool("shadows") ? 1 : 0;
   softshadowsbutton->togglestate = console.GetBool("softshadows") ? 1 : 0;
   reflectionbutton->togglestate = console.GetBool("reflection") ? 1 : 0;
   fullscreenbutton->togglestate = console.GetBool("fullscreen") ? 1 : 0;
   turnsmoothslider->value = console.GetInt("turnsmooth");
   mousespeedslider->value = console.GetInt("mousespeed");
   weaponfocusslider->value = console.GetInt("weaponfocus");
   nameedit->text = console.GetString("name");
   
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
   
   console.Parse("setsave partupdint " + ToString(partupdintslider->value), false);
   // Not implemented yet
   //console.Parse("set partcount " + ToString(partcountslider->value), false);
   console.Parse("setsave viewdist " + ToString(viewdistslider->value), false);
   console.Parse("setsave grassdensity " + ToString(float(grassdensityslider->value) / 100.f), false);
   console.Parse("setsave grassdist " + ToString(grassdistslider->value), false);
   console.Parse("setsave impdistmulti " + ToString(impdistslider->value), false);
   console.Parse("setsave shadows " + ToString(shadowsbutton->togglestate), false);
   console.Parse("setsave softshadows " + ToString(softshadowsbutton->togglestate), false);
   console.Parse("setsave reflection " + ToString(reflectionbutton->togglestate), false);
   console.Parse("setsave fullscreen " + ToString(fullscreenbutton->togglestate), false);
   console.Parse("setsave turnsmooth " + ToString(turnsmoothslider->value), false);
   console.Parse("setsave mousespeed " + ToString(mousespeedslider->value), false);
   console.Parse("setsave weaponfocus " + ToString(weaponfocusslider->value), false);
   console.Parse("setsave aa " + ToString(aabox->SelectedText()), false);
   console.Parse("setsave af " + ToString(afbox->SelectedText()), false);
   console.Parse("setsave name " + nameedit->text, false);
   
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
