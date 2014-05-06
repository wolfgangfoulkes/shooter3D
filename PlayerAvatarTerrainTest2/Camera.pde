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
    laser = 0.0;
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
    
    laser = (laser >= .01) ? laser * .85 : 0;
    SHADER_CROSSHAIR.set("time", millis() * .001);
    SHADER_CROSSHAIR.set("resolution", (float) width, (float) height);
    SHADER_CROSSHAIR.set("mouse", (float) width/2, (float) (-acc.y * height/2) + height/2);
    
    SHADER_CROSSHAIR.set("circle_radius", .08 + (laser * .04)); //relative to center of screen.
    SHADER_CROSSHAIR.set("border", .04 + (laser * .08)); 
    SHADER_CROSSHAIR.set("mix", .6); 
    SHADER_CROSSHAIR.set("circles", (1 - laser) * (1 - laser) * 2000.0);
    SHADER_CROSSHAIR.set("pulse", 5.0 );
    
    filter(SHADER_CROSSHAIR);
    println("acc.y", acc.y);
    
  }
  
}
