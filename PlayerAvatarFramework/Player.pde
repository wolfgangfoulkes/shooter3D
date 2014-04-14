class Player
{
  
  String IP;
  int port;
  Avatar avatar;
  
  Player(String iIP, int iport)
  {
    
    IP = iIP;
    port = iport;
    avatar = null;
  }

  NetAddress getNetAddress()
  {
    return new NetAddress(IP, port);
  }
}
