class Avatar extends O3DCone
{
  Player player;
  //boolean isLiving;
  Laser laser;
  
  
  Avatar(Player iplayer, PVector ip, PVector ir, PVector isize)
  {
    super(ip, ir, isize);
    type = "avatar";
    player = iplayer;
    laser = new Laser(1.0, 1.0, 1.0, 1.0, apex); //set it to apex, later.
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
    super.display();
    laser.update(); //right now, this's all that'd be in "update" for any object excepting the camera.
    laser.display();
  }
  
  void startLaser(PVector ipos, PVector iaim)
  {
    laser.set(ipos, iaim, .88);//laser.adjustToTerrain?
  }
  
  void startLaser(PVector iaim)
  {
    laser.set(p, iaim, .88); //laser.adjustToTerrain?
  }
  
  void print()
  {
    println("Avatar for player "+player.prefix+"", "position:", p, "rotation", r);
  }
}
