#ifndef SERVERNETCODE_H
#define SERVERNETCODE_H

#include "NetCode.h"
#include "Item.h"
#include "PlayerData.h"
#include "Particle.h"
#include <set>
#include <boost/shared_ptr.hpp>

using std::set;

class SortableIPaddress
{
   public:
      //SortableIPaddress() : addr(INADDR_NONE){}
      SortableIPaddress(const IPaddress& a) : addr(a){}
      bool operator<(const SortableIPaddress& a) const
      {
         if (addr.host != a.addr.host) return addr.host < a.addr.host;
         return addr.port < a.addr.port;
      }
      
      IPaddress addr;
};

class ServerNetCode : public NetCode
{
   public:
      ServerNetCode();
      void ClearValidAddrs() {validaddrs.clear();}
      void EraseValidAddr(IPaddress& addr) {validaddrs.erase(SortableIPaddress(addr));}

      void SendItem(const Item&, int);
      void SendKill(size_t, size_t);
      void SendToAll(Packet, const size_t exclude = 0);
      void SendSyncPacket(PlayerData&, unsigned long);
      void SendGameOver(PlayerData&, const int);
      void SendShot(const Particle&);
      void SendHit(const Vector3&, const Particle&);
      void SendDamage(const int);
      void SendRemove(const int, const int);
      void SendMessage(const string&);

   protected:
      virtual void HandlePacket(stringstream&);
      void ReadUpdate(stringstream&);
      void ReadConnect(stringstream&);
      void HandleInfo();
      void ReadSpawn(stringstream&);
      void ReadChat(stringstream&);
      void ReadAck(stringstream&);
      void ReadTeamChange(stringstream&);
      void HandleUseItem();
      void HandleKill();
      void HandleSync();
      void HandlePowerDown();
      void ReadCommand(stringstream&);
      void HandleFire();
      void ReadAuthentication(stringstream&);
      void HandleLoadout();

      virtual void Send();
      void Ack(const unsigned long, UDPpacket*);

      size_t playernum;
      set<SortableIPaddress> validaddrs;
      int pingtick;
      IDGen nexthitid;

};

typedef boost::shared_ptr<ServerNetCode> ServerNetCodePtr;

#endif // SERVERNETCODE_H
