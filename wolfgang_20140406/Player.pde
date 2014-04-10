class Player extends Object3D
{
  String tag; //don't need this in a HashMap, but I could anyway.
  
  Player(PVector ipos, PVector irot, String itag)
  {
    super(ipos.x, ipos.y, ipos.z, irot.x, irot.y, irot.z);
    tag = itag;
  }
  
  void destroy()
  {
    //OSC stuff here?
  }
  
  String getType()
  {
    return "player";
  }
  
  //void display //will need to override display if players look different.
}
