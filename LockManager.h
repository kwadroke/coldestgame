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

#ifndef __LOCKMANAGER_H
#define __LOCKMANAGER_H

#include <map>
#include "RWLock.h"

using std::map;

class LockManager
{
   private:
      map<const void*, RWLockPtr> locks;
      
   public:
      LockManager(){}
      ~LockManager(){}
      
      template <typename T>
      void Register(const T& object)
      {
         if (locks.find(&object) == locks.end())
            locks[&object] = RWLockPtr(new RWLock());
      }
      
      template <typename T>
      void Read(const T& object)
      {
         locks[&object]->Read();
      }
      
      template <typename T>
      void EndRead(const T& object)
      {
         locks[&object]->EndRead();
      }
      
      template <typename T>
      void Write(const T& object)
      {
         locks[&object]->Write();
      }
      
      template <typename T>
      void EndWrite(const T& object)
      {
         locks[&object]->EndWrite();
      }
};
#endif
