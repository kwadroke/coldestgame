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
#ifndef UPDATER_H
#define UPDATER_H

#include <boost/crc.hpp>
#include <curl/curl.h>
#include "defines.h"
#include "renderdefs.h"
#include <vector>
#include <string>
#include <boost/shared_ptr.hpp>
#ifndef _WIN32
#include <boost/filesystem.hpp>
#else
#include <process.h>
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
      void Cancel() {cancelled = true;}

      tsint current, total;
      tsint cancelled, finished;
      tsint currentfile;
      
   private:
      Updater(const Updater&);
      Updater& operator=(const Updater&);
      void BuildFileList();
      void GetNewFiles();
      static int StartDownloadThread(void*);
      void DownloadThread();
      static int ProgressCallback(void*, double, double, double, double);
      void CreateParentDirectory(const string&);
      void ReplaceAndRestart();

      CURL* handle;
      vector<string> filelist;
      static string remotebase;
};

typedef boost::shared_ptr<Updater> UpdaterPtr;

#endif
