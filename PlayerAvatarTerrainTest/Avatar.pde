class Avatar extends O3DObelisk
{
  Player player;
  //boolean isLiving;
  Laser laser;
  
  
  Avatar(Player iplayer, PVector ip, PVector ir)
  {
    super(applet, ip, ir, 100);
    player = iplayer;
    laser = new Laser(5.0, 5.0, 5.0, 5.0, p);
    //isLiving = true; //might want to keep it dead until it's initialized
    //println("new Avatar!", p, r, player.prefix);
  }
  
  void destroy() //overrides base class
  {
  }
  
  void display()
  {
    obelisk.moveTo(p);
    obelisk.rotateToY(radians(r.y));
    p = obelisk.getPosVec();
    r = obelisk.getRotVec();
    obelisk.draw();
    laser.update();
    laser.display();
  }
  
  void startLaser(PVector iaim)
  {
    laser.set(p, iaim, .001, .001);
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
