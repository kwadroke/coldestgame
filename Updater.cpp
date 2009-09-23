#include "Updater.h"

Updater::Updater()
{
   handle = curl_easy_init();
   if (!handle)
      logout << "Warning: Updater failed to initialize curl.  Updating will not be possible." << endl;
}


Updater::~Updater()
{
   curl_easy_cleanup(handle);
}


bool Updater::Available()
{
   currversion = 0;
   if (!SendVersionRequest())
      return false;
   
   // Wait for response
   logout << "Sent request" << endl;
   while (!currversion) {SDL_Delay(1);}
   logout << "Got reply" << endl;
   
   if (currversion > thisversion)
      return true;
   return false;
}


void Updater::DoUpdate()
{
   if (!Available() || !handle)
      return;
   
   // Get list of all files and CRC's
   curl_easy_setopt(handle, CURLOPT_URL, "www.coldestgame.com/files/crclist");
   curl_easy_perform(handle);
}


