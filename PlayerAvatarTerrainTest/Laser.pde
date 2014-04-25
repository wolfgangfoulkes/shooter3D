class Laser 
{
  Tube laser;
  float lifespan;
  float rate;
  float decc;
  
  Laser(float rTopX, float rTopZ, float rBotX, float rBotZ, PVector ipos)
  {
    lifespan = 0;
    rate = 0;
    decc = 0;
    laser = new Tube(applet, 10, 30);
    laser.setSize(rTopX, rTopZ, rBotX, rBotZ);
    laser.setWorldPos(ipos, ipos);
    laser.visible(false);
  }
  
  void set(PVector ipos, PVector iaim, float irate)
  {
    laser.visible(false);
    laser.setWorldPos(ipos, iaim);
    lifespan = 1;
    rate = irate;
  }
  
  void update()
  {
    if (lifespan >= .001)
    {
      lifespan -= rate;
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
    fill((int) (360 * lifespan));
    if (lifespan > 0)
    {
      laser.visible(true);
      laser.draw();
    }
    else 
    {
      laser.visible(false);
    }
  }
}
