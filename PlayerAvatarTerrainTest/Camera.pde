class Camera
{
 TerrainCam cam;
 PVector pos; //camera "eye"
 PVector rot; //camera angle
 PVector look; //camera "center"
 boolean living;

  Camera (PApplet iapp)
  {
    cam = new TerrainCam(iapp);
    pos = new PVector(0, 0, 0);
    rot = new PVector(0, 0, 0);
    look = new PVector(0, 0, 1);
    living = false;
  }
  
  PVector spawnCamera(PVector ipos, PVector irot)
  {
    pos = ipos;
    rot = irot;
    cam.eye(pos);
    cam.rotateViewTo(radians(rot.x)); //unnecessary, covered by look() from rot.
    cam.turnTo(radians(rot.x)); //unnecessary, covered by look() from rot.
    look = cam.lookDir();
    living = true;
    cam.speed(1);
    
    return cam.eye();
  }

  void look(float ix, float iy, float ir) 
  {
    rot.x += ix; //already in degrees.
    cam.rotateViewTo(radians(0));
    cam.rotateViewTo(radians(rot.x));
    // look at 
    look.x = cam.lookDir().x; //lookdir is a normalized vector, so between 0 and 1 to represent direction.
    look.y = iy;
    look.z = cam.lookDir().z;
    //x and z are the floor plane, if that makes any sense 
    
    println(cam.lookDir());
    //for now.
    pushMatrix();
    PVector llook = PVector.add(pos, PVector.mult(look, 100));;
    translate(llook.x, llook.y, llook.z);
    rotateY(radians(90 - rot.x)); //think it's this value because the camera looks to the positive x axis.
    stroke(255);
    fill(255);
    rect(0, 0, 10, 10);
    popMatrix();
    

  }
  
PVector pInfo(){
  return pos;
}

PVector lInfo(){
 return look; 
}
  
  void move(PVector ipos)
  {
    long time = millis();
    cam.turnTo(radians(rot.x));
    cam.move(ipos.x);
    cam.turnTo(radians(rot.z + 90));
    cam.move(ipos.z);
    
    pos.x = cam.eye().x;
    pos.z = cam.eye().z;
    //println(pos);
  }

  void run() //sorta redundant.
  {
    this.display();
  }

  void display()
  {
  //corrected crosshair position: //these values work for the runner3 means of setting camera-look.
     pushMatrix();
     translate(look.x, 0, look.z);
     rotateY(radians(rot.x));
     box(5, 5, 5);
     popMatrix();
  }
  
}


