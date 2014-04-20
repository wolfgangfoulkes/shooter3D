class Avatar extends O3DObelisk
{
  Player player;
  //boolean isLiving;
  
  
  Avatar(Player iplayer, PVector ip, PVector ir)
  {
    super(applet, ip, ir, 100.0);
    player = iplayer;
    //isLiving = true; //might want to keep it dead until it's initialized
    //println("new Avatar!", p, r, player.prefix);
  }
  
  void destroy() //overrides base class
  {
  }
  
  String getType()
  {
    return "avatar";
  }
  
  void print()
  {
    println("Avatar for player "+player.prefix+"", "position:", p, "rotation", r);
  }
}
