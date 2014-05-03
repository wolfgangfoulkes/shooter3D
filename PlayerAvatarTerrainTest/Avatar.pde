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
    laser = new Laser(1.0, 1.0, 1.0, 1.0, new PVector(p.x, p.y-isize.y, p.z)); //set it to apex, later.
    //isLiving = true; //might want to keep it dead until it's initialized
    println("new Avatar!", p, r, player.prefix);
  }
  
  void destroy() //overrides base class
  {
  }
  
  void update()
  {
  }

  void display()
  {
    
    super.display();
    resetShader();
    lasershader.set("time", millis()); //elapsed could be set to the initial elapsed value, then mod by that number to get count from 0
    lasershader.set("time", (millis() % 10000) * .001); //elapsed could be set to the initial elapsed value, then mod by that number to get count from 0
    lasershader.set("resolution", (float) width, (float) height);
    lasershader.set("alpha", laser.lifespan);
    shader(lasershader);
    laser.update(); //right now, this's all that'd be in "update" for any object excepting the camera.
    laser.display();
    resetShader();
  }
  
  void startLaser(PVector ipos, PVector iaim)
  {
    laser.set(ipos, iaim, .88);//laser.adjustToTerrain?
  }
  
  void startLaser(PVector iaim)
  {
    laser.set(new PVector(p.x, p.y-size.y, p.z), iaim, .88); //laser.adjustToTerrain?
  }
  
  void print()
  {
    println("Avatar for player "+player.prefix+"", "position:", p, "rotation", r);
  }
}
