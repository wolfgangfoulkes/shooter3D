class Avatar extends O3DObelisk
{
  Player player;
  //boolean isLiving;
  Laser laser;
  
  
  Avatar(Player iplayer, PVector ip, PVector ir)
  {
    super(ip, ir, new PVector(random(10, 30), random(80, 100), random(10, 30)));
    type = "avatar";
    player = iplayer;
    laser = new Laser(2.0, 2.0, 2.0, 2.0, p); //set it to apex, later.
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
  
  void startLaser(PVector ipos, PVector iaim)
  {
    laser.set(ipos, iaim, .9);//laser.adjustToTerrain?
  }
  
  void startLaser(PVector iaim)
  {
    laser.set(p, iaim, .9); //laser.adjustToTerrain?
  }
  
  void print()
  {
    println("Avatar for player "+player.prefix+"", "position:", p, "rotation", r);
  }
}
