class Player extends Object3D
{
  String IP; //don't need this in a HashMap, but I could anyway.
  int port;
  
  Player(PVector ipos, PVector irot, String IPin, int iport)
  {
    super(ipos.x, ipos.y, ipos.z, irot.x, irot.y, irot.z);
    IP = IPin;
    port = iport
  }
  
  void destroy()
  {
    //OSC stuff here?
  }
  
  NetAddress getNetAddress()
  {
    return new NetAddress(IP, port);
  }
  
  String getType()
  {
    return "player";
  }
  
  //void display //will need to override display if players look different.
}
