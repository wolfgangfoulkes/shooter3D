class Avatar extends O3DObelisk
{
  Player player;
  //boolean isLiving;
  Laser laser;
  
  
  Avatar(Player iplayer, PVector ip, PVector ir)
  {
    super(applet, ip, ir, new PVector(20, 150, 50));
    type = "avatar";
    player = iplayer;
    laser = new Laser(5.0, 5.0, 5.0, 5.0, p);
    //isLiving = true; //might want to keep it dead until it's initialized
    println("new Avatar!", p, r, player.prefix);
  }
  
  void destroy() //overrides base class
  {
  }
  
  void update()
  {
  }
  
  void adjustToTerrain(Terrain iterrain)
  {
    super.adjustToTerrain(iterrain);
    //laser.adjustToTerrain(iterrain);
  }
  
  void display()
  {
    obelisk.draw();
    laser.update(); //right now, this's all that'd be in "update" for any object excepting the camera.
    laser.display();
  }
  
  void startLaser(PVector iaim)
  {
    laser.set(p, iaim, .95); //laser.adjustToTerrain?
  }
  
  void print()
  {
    println("Avatar for player "+player.prefix+"", "position:", p, "rotation", r);
  }
}
