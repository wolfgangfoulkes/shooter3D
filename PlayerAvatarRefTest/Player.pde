class Player
{
  int lport;
  String IP;
  Avatar avatar;
  
  Player(int ilport, String iIP)
  {
    lport = ilport;
    IP = iIP;
    avatar = null;
    println("new Player!", lport, IP);
    //avatar = new Avatar(this); //could just initialize null
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
    return new NetAddress(IP, lport);
  }
}
