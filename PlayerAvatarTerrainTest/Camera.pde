class Camera
{
 TerrainCam cam;
 PVector pos; //camera "eye"
 PVector rot; //camera angle
 PVector look; //camera "center"
 PVector move; //next position
 boolean living;
 
 PVector aim;
 float aimheight;
 
 float laser;

  Camera (PApplet iapp)
  {
    cam = new TerrainCam(iapp);
    pos = new PVector(0, 0, 0);
    move = new PVector(0, 0, 0);
    rot = new PVector(0, 0, 0);
    look = new PVector(0, 0, 1);
    aim = PVector.add(pos, PVector.mult(look, 500));
    aimheight = 0;
    living = false;
  }
  
  PVector spawnCamera(PVector ipos, PVector irot)
  {
    pos = ipos;
    rot = irot;
    cam.eye(pos);
    look = cam.lookDir();
    aim = PVector.add(pos, PVector.mult(look, 200));
    living = true;
    
    return cam.eye();
  }

  void look(float iy, float ih) 
  {
    rot.y += iy; //already in degrees.
    cam.rotateViewTo(radians(-rot.y));
    look.x = cam.lookDir().x; //lookdir is a normalized vector, so between 0 and 1 to represent direction.
    look.y = 0;
    look.z = cam.lookDir().z;
    aimheight = constrain(aimheight + ih, -200, 150); //remember these are real values.
    aim = PVector.add(pos, PVector.mult(look, 500));
    aim.y += aimheight; //gotta limit this so it doesn't go off the map (limit more than that).
    //println(aim);
    //println(aimheight);

  }
  
PVector pInfo(){
  return pos;
}

PVector lInfo(){
 return look; 
}
  
  void move(PVector ipos)
  {
    move = PVector.add(PVector.mult(look, ipos.x), new PVector(-(look.z * ipos.z), 0, look.x * ipos.z)); //flip signs to flip left/right
  }
  
  void update()
  {
    pos.add(move);
    cam.eye(pos);
  }
  
  void adjustToTerrain(Terrain iterrain, float iheight)
  {
    pos = adjustY(pos, iterrain, iheight);
    cam.eye(pos);
  }

  void display()
  {
    cam.camera();
    
    laser = (laser >= .12) ? laser * .98 : 0;
    crosshair.set("time", millis() * .001);
    crosshair.set("resolution", (float) width, (float) height);
    crosshair.set("mouse", (float) width/2, (float) (acc.y * height/2) + height/2);
    crosshair.set("opacity", laser);
    crosshair.set("ir", 1.0);
    crosshair.set("ig", 1.0);
    crosshair.set("ib", 1.0);
    filter(crosshair);
    println("acc.y", acc.y);
    
    PVector ch = PVector.add(pos, PVector.mult(look, 1)); //could scale the sight further. does a sight further from the eye have more accuracy?
    ch.y += (aimheight * .002); //gotta do it here, because we don't wanna affect the real aimheight
    pushMatrix();
    translate(ch.x, ch.y, ch.z);
    rotateY(radians(90 + rot.y)); //think it's this value because the camera looks to the positive x axis.
    
    stroke(255);
    fill(255);
    rectMode(CENTER);
    rect(0, 0, .05, .05);
    
    popMatrix();
    
    
    
  }
  
}
