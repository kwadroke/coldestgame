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
// Copyright 2008-2012 Ben Nemec
// @End License@
#include "Updater.h"
#include "globals.h"
#include "util.h"

#ifdef _WIN32
string Updater::remotebase = "updates/windows/32bit/";
#elif defined(__amd64)
string Updater::remotebase = "updates/linux/x86_64/";
#elif defined(__i686)
string Updater::remotebase = "updates/linux/i686/";
#else
#error Platform not supported
#endif

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
   if (!console.GetBool("checkupdates"))
      return false;
   GUI* progresstext = gui[updateprogress]->GetWidget("progresstext");
   progresstext->text = "Checking for updates";
   Repaint();

   logout << "Sending version request" << endl;
   if (!netcode->SendVersionRequest())
   {
      logout << "Updater: Failed to contact master server" << endl;
      return false;
   }
   
   // Wait for response
   logout << "Waiting for master server version" << endl;
   Timer t;
   t.start();
   while (!netcode->CurrVersion())
   {
      netcode->Update();
      SDL_Delay(1);
      if (t.elapsed() > 15000)
      {
         logout << "Timed out waiting for master server version" << endl;
         return false;
      }
      GuiUpdate();
      if (cancelled)
         return false;
   }
   
   long thisversion;
   ifstream getver("version");
   if (getver)
      getver >> thisversion;
   else
      thisversion = 0;

   if (netcode->CurrVersion() > thisversion)
      return true;
   return false;
}


void Updater::DoUpdate()
{
   if (!Available() || !handle)
      return;
   
   // Get list of all files and CRC's
   FILE* cfile;
   
   string crcfile = "www.coldestgame.com/files/" + remotebase + "crcfile";
   curl_easy_setopt(handle, CURLOPT_URL, crcfile.c_str());
   cfile = fopen("crcfile", "wb");
   curl_easy_setopt(handle, CURLOPT_WRITEDATA, cfile);
   curl_easy_perform(handle);
   fclose(cfile);
   
   BuildFileList();
   
   if (!filelist.size())
      return;
   
   GetNewFiles();

   if (cancelled)
      return;
   
   ReplaceAndRestart();
}


void Updater::BuildFileList()
{
   NTreeReader crcs("crcfile");
   uint32_t currcrc;
   string currfile;

   for (size_t i = 0; i < crcs.NumChildren(); ++i)
   {
      const NTreeReader& current = crcs.GetItem(i);
      
      current.Read(currcrc, "CRC");
      currfile = current.GetName();
      
      boost::crc_32_type getcrc;
      ifstream in(currfile.c_str(), ios::binary);
      
      if (in)
      {
         while (in)
         {
            char buffer[32768];
            in.read(buffer, 32768);
            getcrc.process_bytes(buffer, in.gcount());
         }
      }
      
      if (currcrc != getcrc.checksum())
         filelist.push_back(currfile);
   }
}


void Updater::GetNewFiles()
{
   GUI* progresstext = gui[updateprogress]->GetWidget("progresstext");
   GUI* fileprogresstext = gui[updateprogress]->GetWidget("fileprogresstext");
   ProgressBar* updateprogressbar = dynamic_cast<ProgressBar*>(gui[updateprogress]->GetWidget("updateprogressbar"));
   ProgressBar* fileprogressbar = dynamic_cast<ProgressBar*>(gui[updateprogress]->GetWidget("fileprogressbar"));
   updateprogressbar->SetRange(0, filelist.size());

   vector<string> locallist = filelist;
   SDL_Thread* thread;

   thread = SDL_CreateThread(StartDownloadThread, this);

   while (!finished)
   {
      SDL_Delay(1);
      
      if (cancelled)
         break;
      
      progresstext->text = "Downloading " + locallist[currentfile];
      updateprogressbar->value = currentfile;
      fileprogressbar->value = current;
      fileprogressbar->SetRange(0, total);
      fileprogresstext->text = ToString(current) + " KB /" + ToString(total) + " KB";
      
      GuiUpdate();
   }

   SDL_WaitThread(thread, NULL);

   progresstext->text = "Finished Updating";
   updateprogressbar->value = filelist.size();
   Repaint();
   SDL_Delay(1000);
}


void Updater::GuiUpdate()
{
   SDL_Event event;
   while(SDL_PollEvent(&event))
   {
      gui[updateprogress]->ProcessEvent(&event);
   }
   Repaint();
}


//static
int Updater::StartDownloadThread(void* obj)
{
   setsighandler();
   
   logout << "Download thread id " << gettid() << " started." << endl;
   
   ((Updater*)obj)->DownloadThread();
   return 0;
}


void Updater::DownloadThread()
{
   FILE* getfile;
   string currfile, localfile;
   for (size_t i = 0; i < filelist.size(); ++i)
   {
      currentfile = i;
      currfile = remotebase + filelist[i];
      localfile = "updates/" + filelist[i];
      CreateParentDirectory(localfile);
      
      getfile = fopen(localfile.c_str(), "wb");
      logout << "Downloading " << currfile << endl;
      string curlpath = "www.coldestgame.com/files/" + currfile;
      curl_easy_setopt(handle, CURLOPT_URL, curlpath.c_str());
      curl_easy_setopt(handle, CURLOPT_WRITEDATA, getfile);
      curl_easy_setopt(handle, CURLOPT_NOPROGRESS, 0);
      curl_easy_setopt(handle, CURLOPT_PROGRESSFUNCTION, &Updater::ProgressCallback);
      curl_easy_setopt(handle, CURLOPT_PROGRESSDATA, this);
      curl_easy_perform(handle);
      
      if (cancelled)
         break;
      
      fclose(getfile);
   }
   finished = 1;
}

//static
int Updater::ProgressCallback(void* clientp, double dltotal, double dlnow, double ultotal, double ulnow)
{
   Updater* obj = (Updater*)clientp;
   obj->current = dlnow / 1024;
   obj->total = dltotal / 1024;
   if (obj->cancelled)
      return 1;
   return 0;
}


void Updater::CreateParentDirectory(const string& filename)
{
   vector<string> dirs = split(filename, "/");
   
   // The last entry in dirs is the filename
   for (size_t i = 0; i < dirs.size() - 1; ++i)
   {
      string curr;
      for (size_t j = 0; j <= i; ++j)
      {
         curr += dirs[j] + "/";
      }
#ifndef WIN32
      if (!boost::filesystem::is_directory(curr))
         boost::filesystem::create_directory(curr);
#else
      CreateDirectory((TCHAR*)curr.c_str(), NULL);
#endif
   }
}


void Updater::ReplaceAndRestart()
{
   int error;
   
   // Need to release our network ports
   Cleanup();
#ifndef WIN32
   // This is a bit lazy, but it should work on any Unix-like that allows you to replace in-use files
   error = system("cp -rf updates/* .");
   if (error)
   {
      logout << "Error copying update files: " << error << endl;
   }
   error = system("rm -rf updates/*");
   if (error)
   {
      logout << "Error removing temporary update files: " << error << endl;
   }
   error = system("chmod +x ./coldest* ./server*");
   if (error)
   {
      logout << "Error setting execute bit: " << error << endl;
   }
   logout << "Restarting" << endl;
   execlp("./coldest.bin", "./coldest.bin", (char*) NULL);
#else
   error = system("move /Y Coldest.exe Coldest.old");
   if (error)
   {
      logout << "Error moving executable: " << error << endl;
   }
   error = system("xcopy /Y /E updates\\*");
   if (error)
   {
      logout << "Error copying update files: " << error << endl;
   }
   _execlp("Coldest.exe", "Coldest.exe", (char*) NULL);
#endif
}


