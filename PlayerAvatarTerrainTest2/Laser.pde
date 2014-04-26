class Laser 
{
  Tube laser;
  PVector pos;
  PVector aim;
  float lifespan;
  float rate;
  float decc;
  
  Laser(float rTopX, float rTopZ, float rBotX, float rBotZ, PVector ipos)
  {
    pos = ipos;
    aim = ipos;
    lifespan = 0;
    rate = 0;
    decc = 0;
    laser = new Tube(applet, 10, 30);
    laser.setSize(rTopX, rTopZ, rBotX, rBotZ);
    laser.setWorldPos(pos, aim);
    laser.visible(false);
  }
  
  void set(PVector ipos, PVector iaim, float irate)
  {
    pos = ipos;
    aim = iaim;
    laser.visible(false);
    laser.setWorldPos(pos, aim);
    lifespan = 1;
    rate = irate;
  }
  
  void update()
  {
    if (lifespan >= .001)
    {
      lifespan *= rate;
      println(lifespan);
    }
    else
    {
     lifespan = 0;
     rate = 0;
    }
    
  }
  
  /*
  void adjustToTerrain(Terrain iterrain)
  {
    iterrain.adjustY(p);
    this.update();
  }
  */
  
  void display() //the actual visual here is kinda whatever.
  {
    int ifill = floor(240 * lifespan);
    pos = PVector.lerp(pos, aim, 1 - lifespan);
    laser.setWorldPos(pos, aim);
    laser.fill(ifill);
    if (lifespan > 0)
    {
      laser.visible(true);
      laser.draw();
    }
    else 
    {
      laser.visible(false);
      //laser.draw():
    }
  }
}
