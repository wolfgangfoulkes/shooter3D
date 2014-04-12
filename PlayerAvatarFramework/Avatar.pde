class Avatar extends Object3D
{
  Player player;
  //boolean isLiving;
  
  Avatar(Player iplayer)
  {
    super();
    player = iplayer;
    //isLiving = false;
  }
  
  Avatar(Player iplayer, PVector ipos, PVector irot)
  {
    super(ipos.x, ipos.y, ipos.z, irot.x, irot.y, irot.z);
    player = iplayer;
    //isLiving = true; //might want to keep it dead until it's initialized
  }
  
  void move()
  {
  }
  
  void destroy()
  {
  }
  
  NetAddress getNetAddress()
  {
    return player.getNetAddress();
  }
}
