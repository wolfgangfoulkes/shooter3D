class Laser 
{
  Tube laser;
  PVector pos;
  PVector aim;
  float lifespan;
  float rate;
  int elapsed;
  
  Laser(float rTopX, float rTopZ, float rBotX, float rBotZ, PVector ipos)
  {
    pos = ipos;
    aim = PVector.add(ipos, new PVector(0, 0, -1)); //radius must be >=0.
    lifespan = 0;
    rate = 0;
    elapsed = 0;
    laser = new Tube(APPLET, 10, 30);
    laser.visible(false);
    laser.setSize(rTopX, rTopZ, rBotX, rBotZ);
    laser.setWorldPos(pos, aim);
    
  }
  
  void set(PVector ipos, PVector iaim, float irate)
  {
    pos = ipos;
    aim = iaim;
    laser.visible(false);
    laser.setWorldPos(pos, aim);
    lifespan = 1;
    rate = irate;
    elapsed = 0;
  }
  
  void update()
  {
    elapsed++;
    if (lifespan >= .08)
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
  
  void display() //the actual visual here is kinda whatever.
  {
    //int itint = floor(255 * lifespan);
    //pos = PVector.lerp(pos, aim, 1 - lifespan); //start -> end
    PVector lpos = PVector.lerp(pos, aim, 1 - lifespan); 
    laser.setWorldPos(pos, lpos); //end -> end
    laser.drawMode(S3D.TEXTURE);
    laser.setTexture(laserTexCur);
    if (lifespan > 0)
    {
      pushStyle();
      laser.visible(true);
      //tint(255, 255, 255, itint);
      laser.draw();
      popStyle();
      
    }
    else 
    {
      laser.visible(false);
      laser.draw();
    }

  }
}
