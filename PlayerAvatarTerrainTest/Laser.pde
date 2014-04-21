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
  
  void set(PVector istartPos, PVector iendPos, float irate, float idecc)
  {
    laser.visible(false);
    laser.setWorldPos(istartPos, iendPos);
    lifespan = 1;
    rate = irate;
    decc = idecc;
  }
  
  void update()
  {
    if (lifespan >= .001)
    {
      lifespan -= rate;
      rate *= decc;
    }
    else
    {
     lifespan = 0;
     rate = 0;
     decc = 0;

    }
    
  }
  
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
