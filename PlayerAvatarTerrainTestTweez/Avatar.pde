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
        lifespan *= .98;
        //println("lifespan", lifespan);
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
      if (melee > 0) { shader(SHADER_LASER); }
      super.display();
      resetShader();
      SHADER_LASER.set("time", (millis() % 10000) * .001); //elapsed could be set to the initial elapsed value, then mod by that number to get count from 0
      println("millis:", (millis() % 10000) * .001);
      SHADER_LASER.set("resolution", (float) width, (float) height);
      SHADER_LASER.set("alpha", laser.lifespan * 2);
      //if (laser.lifespan > 0) { println(laser.lifespan); } 
      shader(SHADER_LASER);
      laser.update(); //right now, this's all that'd be in "update" for any object excepting the camera.
      laser.display();
      resetShader();
    }
    else if (isLiving == 0)
    {
      
      SHADER_DEATH.set("time", millis() * .001);
      SHADER_DEATH.set("resolution", (float) width, (float) height);
      SHADER_DEATH.set("floor", lerp(.8, 2.0, pow((1 - lifespan), 2))); //lerp(.8, 1.0, (1 - lifespan)));
      SHADER_DEATH.set("ceil", .8);
      SHADER_DEATH.set("alpha", .8);
    
      SHADER_DEATH.set("mouse", (float) width/2, (float) (-acc.y * height/2) + height/2);
    
      SHADER_DEATH.set("circle_radius", lerp(.08, 1.0, (1-lifespan))); //relative to center of screen.
      SHADER_DEATH.set("border", .08); 
      SHADER_DEATH.set("periods", 4.0);
      SHADER_DEATH.set("rate", 50.0);
      
      SHADER_DEATH.set("color", 1.0, 0.0, 0.0); //new PVector(random(1.0), 0.0, random(1.0)));

      shader(SHADER_DEATH);
      
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
  
  void melee()
  {
    melee = 1;
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
