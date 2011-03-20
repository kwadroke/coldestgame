#include "NetCode.h"
#include "ServerInfo.h"
#include "globals.h"
#include <iostream>

using std::endl;

const int NetCode::version = 5;

NetCode::NetCode() : lastnettick(SDL_GetTicks()),
                     currnettick(0),
                     error(false)
{
   sendpacketnum.next(); // 0 has special meaning
   if (!(packet = SDLNet_AllocPacket(5000))) // 5000 is somewhat arbitrary
   {
      logout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      error = true;
   }
}

NetCode::~NetCode()
{
   running = 0;
   SDL_WaitThread(thread, NULL);
   SDLNet_FreePacket(packet);
   SDLNet_UDP_Close(socket);
}


void NetCode::Update()
{
   if (!error)
   {
      Receive();
      Send();
      SendLoop();
   }
}


void NetCode::SendLoop()
{
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
}


void NetCode::SendPacket(Packet& p)
{
   sendqueue.push_back(p);
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
   for (list<Packet>::iterator i = sendqueue.begin(); i != sendqueue.end(); ++i)
   {
      if (i->ack == acknum)
      {
         sendqueue.erase(i);
         break;
      }
   }
}


void NetCode::Ack(const unsigned long acknum)
{
   Packet response(&address);
   response << "A\n";
   response << 0 << eol;
   response << acknum << eol;
   SendPacket(response);
}





