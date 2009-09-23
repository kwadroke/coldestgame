#ifndef UPDATER_H
#define UPDATER_H

#include <boost/crc.hpp>
#include <curl/curl.h>
#include "netdefs.h"

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
      CURL* handle;

};

#endif
