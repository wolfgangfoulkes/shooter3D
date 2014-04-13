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
    //avatar = new Avatar(this); //could just initialize null
  }

  NetAddress getNetAddress()
  {
    return new NetAddress(IP, lport);
  }
}
