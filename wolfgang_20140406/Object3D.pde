class Object3D
{
  PVector p;
  PVector r;
  float radius;
  PImage sprite;
  
  Object3D (float ix, float iy, float iz, float ixr, float iyr, float izr)
  {
    sprite = loadImage("redMonster.jpeg");
    p = new PVector(ix, iy, iz);
    r = new PVector(ixr, iyr, izr);
    radius = 80; //this value needs to be larger than the area of the cube, I guess.
  }
  
  void display()
  {
    stroke(2);
    pushMatrix();
    rotateX(radians(r.x)); //to radians
    rotateY(radians(r.y));
    rotateZ(radians(r.z));
    translate(p.x, p.y, p.z);
    
    box(80, 80, 80);
    //println(modelX(0, 0, 0), modelY(0, 0, 0), modelZ(0, 0, 0));
    popMatrix();
  }
}
