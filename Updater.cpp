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
// Copyright 2008, 2010 Ben Nemec
// @End License@
#include "Updater.h"

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
   
   currversion = 0;
   if (!SendVersionRequest())
      return false;
   
   // Wait for response
   Timer t;
   t.start();
   while (!currversion)
   {
      SDL_Delay(1);
      if (t.elapsed() > 5000)
         return false;
   }
   
   long thisversion;
   ifstream getver("version");
   if (getver)
      getver >> thisversion;
   else
      thisversion = 0;
   
   if (currversion > thisversion)
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
   
   ReplaceAndRestart();
}


void Updater::BuildFileList()
{
   IniReader crcs("crcfile");
   uint32_t currcrc;
   string currfile;
   
   for (size_t i = 0; i < crcs.NumChildren(); ++i)
   {
      const IniReader& current = crcs.GetItem(i);
      
      current.Read(currcrc, "CRC");
      current.Read(currfile, "File");
      
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
   FILE* getfile;
   string currfile, localfile;
   
   GUI* progresstext = gui[updateprogress]->GetWidget("progresstext");
   ProgressBar* updateprogressbar = dynamic_cast<ProgressBar*>(gui[updateprogress]->GetWidget("updateprogressbar"));
   updateprogressbar->SetRange(0, filelist.size());
   
   for (size_t i = 0; i < filelist.size(); ++i)
   {
      currfile = remotebase + filelist[i];
      localfile = "updates/" + filelist[i];
      CreateParentDirectory(localfile);
      
      progresstext->text = "Downloading " + currfile;
      updateprogressbar->value = i;
      Repaint();
      
      getfile = fopen(localfile.c_str(), "wb");
      logout << "Downloading " << currfile << endl;
      string curlpath = "www.coldestgame.com/files/" + currfile;
      curl_easy_setopt(handle, CURLOPT_URL, curlpath.c_str());
      curl_easy_setopt(handle, CURLOPT_WRITEDATA, getfile);
      curl_easy_perform(handle);
      fclose(getfile);
   }
   progresstext->text = "Finished Updating";
   updateprogressbar->value = filelist.size();
   Repaint();
   SDL_Delay(1000);
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
      CreateDirectory(curr.c_str(), NULL);
#endif
   }
}


void Updater::ReplaceAndRestart()
{
   // Need to release our network ports
   Cleanup();
#ifndef WIN32
   // This is a bit lazy, but it should work on any Unix-like that allows you to replace in-use files
   system("mv -f updates/* .");
   system("chmod +x ./coldest*");
   logout << "Restarting" << endl;
   execlp("./coldest.bin", "./coldest.bin", (char*) NULL);
#else
   // Have to do this here or the doupdate.bat file will be in use
   system("move updates\\doupdate.bat");
   _execlp("doupdate.bat", "doupdate.bat", (char*) NULL);
#endif
}


