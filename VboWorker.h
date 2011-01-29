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

#ifndef VBOWORKER_H
#define VBOWORKER_H

#include "Mesh.h"
#include <SDL/SDL_thread.h>
#include <boost/shared_ptr.hpp>

// Set start, end, and position to the appropriate locations, then set go to 1.
// Wait for go to return to 0 before assuming it's safe to continue.

class VboWorker
{
   public:
      VboWorker() : running(1), go(0)
      {
         // Hey stupid, you already made this mistake once - this has to be done after
         // creating the guard values or crashes will result.
         thread = SDL_CreateThread(Start, this);
      }
      
      ~VboWorker()
      {
         running = 0;
         SDL_WaitThread(thread, NULL);
      }
      
      void Run(vector<Mesh*>::iterator s, vector<Mesh*>::iterator e)
      {
         start = s;
         end = e;
         go = 1;
      }
      
      void wait()
      {
         while (go)
         {
            //SDL_Delay(1);
         }
      }
      
   private:
      SDL_Thread* thread;
      // Assignment on ints is atomic on most platforms, and the overhead of locking a tsint
      // gets rather high due to the very tight loop, so these are just declared volatile
      volatile int running;
      volatile int go;
      vector<Mesh*>::iterator start, end;
      
      // No copying
      VboWorker(const VboWorker&);
      VboWorker& operator=(const VboWorker&);
      
      static int Start(void* obj)
      {
         setsighandler();
         
         logout << "Starting worker thread " << gettid() << endl;
         
         ((VboWorker*)obj)->Loop();
         return 0;
      }
      
      
      void Loop()
      {
         while (running)
         {
            while (!go && running) {SDL_Delay(1);}
            
            if (!running) break;
            
            for (vector<Mesh*>::iterator i = start; i != end; ++i)
            {
               Mesh& curr = **i;
               if (curr.VboDirty())
                  curr.GenVbo(Mesh::OnlyData);
            }
            go = 0;
         }
      }
};

typedef boost::shared_ptr<VboWorker> VboWorkerPtr;

#endif
