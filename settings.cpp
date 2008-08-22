#include "globals.h"
#include "gui/Slider.h"

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
   
   partupdintslider->value = console.GetInt("partupdint");
   partcountslider->value = 0;//console.GetInt("partcount");
   viewdistslider->value = console.GetInt("viewdist");
   grassdensityslider->value = console.GetInt("grassdensity");
   grassdistslider->value = console.GetInt("grassdist");
   impdistslider->value = console.GetInt("impdistmulti");
   shadowsbutton->togglestate = console.GetBool("shadows") ? 1 : 0;
   reflectionbutton->togglestate = console.GetBool("reflection") ? 1 : 0;
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
   
   console.Parse("setsave partupdint " + ToString(partupdintslider->value), false);
   // Not implemented yet
   //console.Parse("set partcount " + ToString(partcountslider->value), false);
   console.Parse("setsave viewdist " + ToString(viewdistslider->value), false);
   console.Parse("setsave grassdensity " + ToString(float(grassdensityslider->value) / 100.f), false);
   console.Parse("setsave grassdist " + ToString(grassdistslider->value), false);
   console.Parse("setsave impdistmulti " + ToString(impdistslider->value), false);
   console.Parse("setsave shadows " + ToString(shadowsbutton->togglestate), false);
   console.Parse("setsave reflection " + ToString(reflectionbutton->togglestate), false);
}
