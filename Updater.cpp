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
   currversion = 0;
   if (!SendVersionRequest())
      return false;
   
   // Wait for response
   while (!currversion) {SDL_Delay(1);}
   
   long thisversion;
   ifstream getver("version");
   getver >> thisversion;
   
   logout << currversion << "  " << thisversion << endl;
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
      else
         filelist.push_back(currfile);
      
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
   SDL_Delay(5000);
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
   system("cp -rf updates/* .");
   logout << "Restarting" << endl;
   execlp("./coldest", "./coldest", (char*) NULL);
#else
   // I'm not positive this will work...
   execlp("./doupdate.bat", "./doupdate.bat", (char*) NULL);
#endif
}


