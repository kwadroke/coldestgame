#ifndef UPDATER_H
#define UPDATER_H

#include <boost/crc.hpp>
#include <curl/curl.h>
#include "netdefs.h"
#include "defines.h"
#include "globals.h"
#include "renderdefs.h"
#include <vector>
#include <string>
#ifndef _WIN32
#include <boost/filesystem.hpp>
#endif

/**
	@author Ben Nemec <coldest@nemebean.com>
*/
class Updater
{
   public:
      Updater();
      ~Updater();
      
      bool Available();
      void DoUpdate();
      
   private:
      Updater(const Updater&);
      Updater& operator=(const Updater&);
      void BuildFileList();
      void GetNewFiles();
      void CreateParentDirectory(const string&);
      void ReplaceAndRestart();
      
      CURL* handle;
      vector<string> filelist;
      static string remotebase;
};

#endif
