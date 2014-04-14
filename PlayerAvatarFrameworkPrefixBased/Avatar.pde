class Avatar extends Object3D
{
  Player player;
  //boolean isLiving;
  
  
  Avatar(Player iplayer, PVector ip, PVector ir)
  {
    super(ip, ir);
    player = iplayer;
    //isLiving = true; //might want to keep it dead until it's initialized
     println("new Avatar!", p, r, player.prefix);
  }
  
  void move()
  {
  }
  
  void destroy()
  {
  }
  
  void print()
  {
    println("Avatar for player "+player.prefix+"", "position:", p, "rotation", r);
  }
}
