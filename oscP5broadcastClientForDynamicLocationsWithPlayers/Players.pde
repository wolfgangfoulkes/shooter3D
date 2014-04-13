class Player
{
  String IP;
  
  Player(String IPin)
  {
    IP = IPin;
  }

  NetAddress getNetAddress()
  {
    return new NetAddress(IP, 12000);
  }
}
