class Camera
{
 TerrainCam cam;
 PVector pos; //camera "eye"
 PVector rot; //camera angle
 PVector look; //camera "center"
 PVector move; //next position
 boolean living;
 
 
 PVector ch; //crosshairs.
 float chheight;

  Camera (PApplet iapp)
  {
    cam = new TerrainCam(iapp);
    pos = new PVector(0, 0, 0);
    move = new PVector(0, 0, 0);
    rot = new PVector(0, 0, 0);
    look = new PVector(0, 0, 1);
    ch = PVector.add(pos, PVector.mult(look, 100));
    chheight = 0;
    living = false;
  }
  
  PVector spawnCamera(PVector ipos, PVector irot)
  {
    pos = ipos;
    rot = irot;
    cam.eye(pos);
    look = cam.lookDir();
    ch = PVector.add(pos, PVector.mult(look, 100));
    living = true;
    
    return cam.eye();
  }

  void look(float iy, float ih) 
  {
    rot.y += iy; //already in degrees.
    cam.rotateViewTo(radians(rot.y));
    look.x = cam.lookDir().x; //lookdir is a normalized vector, so between 0 and 1 to represent direction.
    look.y = 0;
    look.z = cam.lookDir().z;
    chheight += ih;
    ch = PVector.add(pos, PVector.mult(look, 100));
    ch.y += chheight;

  }
  
PVector pInfo(){
  return pos;
}

PVector lInfo(){
 return look; 
}

  /*
  void inc(PVector ipos)
  {
    pos += ipos;
  }
  */
  
  void move(PVector ipos)
  {
    move = PVector.add(PVector.mult(look, ipos.x), new PVector(-(look.z * ipos.z), 0, look.x * ipos.z)); //flip signs to flip left/right
    //cam.rotateViewTo(radians(rot.y + 90));
    //println(cam.lookDir());
    //move.add(PVector.mult(cam.lookDir(), ipos.z));
    //cam.rotateViewTo(radians(rot.y));
    //println(cam.lookDir());
  }
  
  void update()
  {
    pos.add(move);
    cam.eye(pos);
  }

  void display()
  {
    cam.camera();
    spotLight(255, 255, 255, pos.x, pos.y, pos.z, look.x, look.y, look.z, radians(180), 800); //concentration: 1 - 10000
    
    pushMatrix();
    translate(ch.x, ch.y, ch.z);
    rotateY(radians(90 - rot.y)); //think it's this value because the camera looks to the positive x axis.
    stroke(255);
    fill(255);
    rect(0, 0, 10, 10);
    popMatrix();
  }
  
}


