#include "NetCode.h"
#include "ServerInfo.h"
#include "globals.h"
#include <iostream>

using std::endl;


NetCode::NetCode() : lastnettick(SDL_GetTicks()),
                     currnettick(0),
                     running(1),
                     error(false)
{
   PreInit();
   if (!(packet = SDLNet_AllocPacket(5000))) // 5000 is somewhat arbitrary
   {
      logout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      error = true;
   }

   thread = SDL_CreateThread(Start, this);
}

NetCode::~NetCode()
{
   running = 0;
   SDL_WaitThread(thread);
   SDLNet_FreePacket(packet);
   SDLNet_UDP_Close(socket);
}


void NetCode::Update()
{
   if (!error)
   {
      Send();
      Receive();
   }
}


void NetCode::SendThread()
{
   while (running)
   {
      SDL_Delay(1); // Prevent this thread from hogging CPU
      sendmutex.lock();
      list<Packet>::iterator i = sendqueue.begin();
      while (i != sendqueue.end())
      {
         if (i->sendtick <= currnettick)
         {
            i->Send(packet, socket);
            if (!i->ack || i->attempts > 100000) // Non-ack packets get sent once and then are on their own
            {
               i = sendqueue.erase(i);
               continue;
            }
         }
         ++i;
      }
      sendmutex.unlock();
   }
}


// static
int NetCode::Start(void* obj)
{
   setsighandler();
   
   logout << "Send thread id " << gettid() << " started." << endl;
   
   ((NetCode*)obj)->SendThread();
   return 0;
}


void NetCode::SendPacket(Packet& p)
{
   sendmutex.lock();
   sendqueue.push_back(p);
   sendmutex.unlock();
}


void NetCode::Receive()
{
   while (SDLNet_UDP_Recv(socket, packet))
   {
      getdata = (char*)packet->data;
      stringstream get(getdata);

      get >> packettype;
      get >> packetnum;

      HandlePacket(get);
   }

   ReceiveExtended();
}


void NetCode::HandleAck(const unsigned long acknum)
{
   sendmutex.lock();
   for (list<Packet>::iterator i = sendqueue.begin(); i != sendqueue.end(); ++i)
   {
      if (i->ack == acknum)
      {
         sendqueue.erase(i);
         break;
      }
   }
   sendmutex.unlock();
}


void NetCode::Ack(const unsigned long acknum)
{
   Packet response(&address);
   response << "A\n";
   response << 0 << eol;
   response << acknum << eol;
   SendPacket(response);
}





