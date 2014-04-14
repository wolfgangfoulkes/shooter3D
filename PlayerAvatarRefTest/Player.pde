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
    println("new Player! IP: "+IP+" port "+port+"");
  }
  
  void initAvatar(PVector ip, PVector ir)
  {
    avatar = new Avatar(this, ip, ir);
  }
  
  void setAvatar(PVector ip, PVector ir) //should be merged with above
  {
    avatar.p = ip;
    avatar.r = ir;
  }

  NetAddress getNetAddress()
  {
    return new NetAddress(IP, port);
  }
}
