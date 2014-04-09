class Camera
{
  laserObject laserO;
 PVector pos; //camera "eye"
 PVector rot; //camera angle
 PVector look; //camera "center"

  Camera ()
  {
    pos = new PVector(0, 0, 0);
    rot = new PVector(0, 0, 0);
    look = new PVector(0, 0, (height/2.0) / tan(PI*30.0 / 180.0));
  }

  void look(float ix, float iy, float ir) 
  {
//line(pos.x, pos.y, pos.z, look.x, look.y, look.z);
    float Radius = ir;  //450

    rot.x += ix; //already in degrees.
    //rot.y += iy;

    // look at 
    look.x = Radius*sin(radians(rot.x)) + pos.x;
    look.y = rot.y; //height, not angle
    look.z = Radius*cos(radians(rot.x)) + pos.z;
    //x and z are the floor plane, if that makes any sense 
    
     
stroke(5);

    pushMatrix();
    //translate(look.x, look.y, look.z);    
    //rectMode(CENTER);
    stroke(255);
    line(displayWidth/2+25,displayHeight/2,pos.z+25,displayWidth/2-25,displayHeight/2,pos.z-25);
    line(displayWidth/2,displayHeight/2,pos.z,displayWidth/2,displayHeight/2-25,pos.z);
    //rect(0, 0, 10, 10);
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
    pos.add(ipos); //further you push the joystick, faster pos increments/decrements
  }

  void run() //sorta redundant.
  {
    this.display();
  }

  void display()
  {
    
    camera (pos.x, 0, pos.z, //no y movement
     look.x, look.y, look.z,
     0.0, 1.0, 0.0
     );
     
     
  }
}


