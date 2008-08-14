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
   
   partupdintslider->value = console.GetInt("partupdint");
   partcountslider->value = 0;//console.GetInt("partcount");
   viewdistslider->value = console.GetInt("viewdist");
   grassdensityslider->value = console.GetInt("grassdensity");
   grassdistslider->value = console.GetInt("grassdist");
   impdistslider->value = console.GetInt("impdistmulti");
}


void SaveSettings()
{
   Slider* partupdintslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("partupdintslider"));
   Slider* partcountslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("partcountslider"));
   Slider* viewdistslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("viewdistslider"));
   Slider* grassdensityslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("grassdensityslider"));
   Slider* grassdistslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("grassdistslider"));
   Slider* impdistslider = dynamic_cast<Slider*>(gui[settings]->GetWidget("impdistslider"));
   
   console.Parse("setsave partupdint " + ToString(partupdintslider->value), false);
   // Not implemented yet
   //console.Parse("set partcount " + ToString(partcountslider->value), false);
   console.Parse("setsave viewdist " + ToString(viewdistslider->value), false);
   console.Parse("setsave grassdensity " + ToString(float(grassdensityslider->value) / 100.f), false);
   console.Parse("setsave grassdist " + ToString(grassdistslider->value), false);
   console.Parse("setsave impdistmulti " + ToString(impdistslider->value), false);
}
