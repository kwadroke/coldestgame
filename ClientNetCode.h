#ifndef CLIENTNETCODE_H
#define CLIENTNETCODE_H

#include "NetCode.h"

class ClientNetCode : public NetCode
{
   public:
      ClientNetCode();
      virtual ~ClientNetCode();

      void Connect();
      void SpawnRequest();
      void SendChat(const string&, const int);
      void ChangeTeam(const int);
      void UseItem();
      void SendKill();
      void SendSync();
      void SendLoadout();
      void SendMasterListRequest();
      void SendPowerdown();
      void SendCommand(const string&);
      void SendFire();
      void SendPassword(const string&);
      void SendKeepalive();
      bool SendVersionRequest();

   protected:
      virtual void PreInit();
      virtual void Send();
      string FillUpdatePacket();

      virtual void ReceiveExtended();
      virtual void HandlePacket(stringstream&);
      // Functions to read from individual packets
      void ReadUpdate(stringstream&);
      void ReadOccUpdate(stringstream&);
      void ReadConnect(stringstream&);
      void ReadFailedConnect(stringstream&);
      void ReadPing(stringstream&);
      void ReadShot(stringstream&);
      void ReadHit(stringstream&);
      void ReadDamage();
      void ReadServerInfo(stringstream&);
      void ReadSpawnRequest(stringstream&);
      void ReadAck(stringstream&);
      void ReadText(stringstream&);
      void ReadTeamChange(stringstream&);
      void ReadServerMessage(stringstream&);
      void ReadDeath(stringstream&);
      void ReadItem(stringstream&);
      void ReadRemoveItem(stringstream&);
      void ReadSync(stringstream&);
      void ReadReconnect();
      void ReadGameOver(stringstream&);
      void ReadRemovePart(stringstream&);
      void ReadAnnounce(stringstream&);
      void ReadVersion(stringstream&);

      bool connected;
      int occpacketcounter;

      UDPsocket annsocket;
      bool annlisten;
};

#endif // CLIENTNETCODE_H
