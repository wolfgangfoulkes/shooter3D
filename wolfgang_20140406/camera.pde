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
    look.x = -Radius*sin(radians(rot.x)) + pos.x;
    look.y = rot.y; //height, not angle
    look.z = -Radius*cos(radians(rot.x)) + pos.z;
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
    //pos.add(ipos);
    
    //forward/back
    pos.x += ipos.x * sin(radians(rot.x)); 
    pos.z += ipos.x * cos(radians(rot.x));
   
    //left/right
    pos.x += ipos.z * sin(radians(rot.x - 90)); 
    pos.z += ipos.z * cos(radians(rot.x - 90));
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
     
     //println(look.x, look.y, look.z);
     //println("position", pos.x, pos.y, pos.z);  
     
//this took a while to figure, but I had to use the specific combination of signs below. look still doesn't correspond, however
//not using it yet because I don't understand it. try to increment position by the Model.xyz here.
//the reason this does not work (I believe) has to do with how position is incremented, which is not in line with the look.x, look.z values. 
//the best way to test this would be to use below in the "look" function to query the position of a single forward, then 
//increment by that number. you could also get the position of "look.x, look.z" from "modelX, modelZ" and set the camera-look to those numbers, and display that
     /*
     beginCamera();
     camera(0, 0, 0, 0, 0, -100, 0, 1, 0);
     rotateY(radians(rot.x));
     translate(-pos.x, pos.y, pos.z); //works with different signs x and z 
     println(modelX(0, 0, -100));
     look.x = modelX(0, 0, -100);
     println(modelZ(0, 0, -100));
     look.z = modelZ(0, 0, -100);
     endCamera();
     */


//corrected crosshair position: //these values work for the runner3 means of setting camera-look.
     pushMatrix();
     translate(look.x, 0, look.z);
     rotateY(radians(rot.x));
     box(5, 5, 5);
     popMatrix();

  }

}


