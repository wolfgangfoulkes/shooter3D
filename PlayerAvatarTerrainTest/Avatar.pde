class Avatar extends O3DCone
{
  Player player;
  //boolean isLiving;
  Laser laser;
  //could have a "shader" parameter that is set along with death and melee. then, we don't have to call so much if/then in display
  //PShader shader;
  float lifespan;
  float melee;
  
  Avatar(Player iplayer, PVector ip, PVector ir, PVector isize)
  {
    super(ip, ir, isize);
    type = "avatar";
    player = iplayer;
    laser = new Laser(1.0, 1.0, 1.0, 1.0, new PVector(p.x, p.y-isize.y, p.z)); //set it to apex, later.
    //shader = SHADER_NOISE;
    println("new Avatar!", p, r, player.prefix);
    isLiving = 1;
    
    lifespan = 0.0;
    melee = 0.0;
  }
  
  void update()
  { 
    if (isLiving == 1)
    {
      if (melee > .1)
      {
        melee *= .88;
        println("melee!");
      }
      else 
      {
        melee = 0;
      }
    }
    else if (isLiving == 0)
    {
      if (lifespan > .1) 
      { 
        lifespan *= .88;
        println("lifespan", lifespan);
      }
      else
      {
        lifespan = 0.0;
        isLiving = -1;
      }
    }
  }

  void display()
  {
    if (isLiving == 1) //rather than these checks, could implement a dig where the shader is set externally, and handle most stuff in-shader with millis()
    {
      
      super.display();
      resetShader();
      lasershader.set("time", (millis() % 10000) * .001); //elapsed could be set to the initial elapsed value, then mod by that number to get count from 0
      lasershader.set("resolution", (float) width, (float) height);
      lasershader.set("alpha", laser.lifespan * 2);
      if (laser.lifespan > 0) { println(laser.lifespan); } 
      shader(lasershader);
      laser.update(); //right now, this's all that'd be in "update" for any object excepting the camera.
      laser.display();
      resetShader();
    }
    else if (isLiving == 0)
    {
      playerdeath.set("time", millis() * .001);
      playerdeath.set("resolution", (float) width, (float) height);
      playerdeath.set("opacity", lifespan);
      shader(playerdeath);
      super.display();
      resetShader();
    }
  }
  
  void startLaser(PVector ipos, PVector iaim)
  {
    laser.set(ipos, iaim, .88);//laser.adjustToTerrain?
  }
  
  void startLaser(PVector iaim)
  {
    laser.set(new PVector(p.x, p.y-size.y, p.z), iaim, .88); //laser.adjustToTerrain?
  }
  
  
  int kill()
  {
    if (isLiving == 1)
    {
      isLiving = 0;
      lifespan = 1.0;
      if (player != null)
      {
        player.avatar = null;
        player = null;
      }
      return 0;
    }
    return -1;
  }
  
  void print()
  {
    println("Avatar for player "+player.prefix+"", "position:", p, "rotation", r);
  }
}
