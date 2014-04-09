/*
class Object3D2
{
  PVector p;
  PVector r;
  float radius;
  PImage sprite;
  
float theta = 0.0;

  Object3D (float ix, float iy, float iz, float ixr, float iyr, float izr)
  {

    p = new PVector(ix, iy, iz);
    r = new PVector(ixr, iyr, izr);
    theta += 0.01;
    //radius = 80; //this value needs to be larger than the area of the cube, I guess.
  }
  
  void display()
  {
    stroke(2);
    pushMatrix();
    rotateX(radians(r.x)); //to radians
    rotateY(radians(r.y));
    rotateZ(radians(r.z));
    translate(p.x, p.y, p.z);
    popMatrix();
  rotateX(theta);
  rotateY(theta);
  drawPyramid(50);
  
  }


void drawPyramid(int t) {
  stroke(0);
  
  // the parameter " t " determines the size of the pyramid
  beginShape(TRIANGLES);
  
  fill(150,0,0,127);
  vertex(-t,-t,-t);
  vertex( t,-t,-t);
  vertex( 0, 0, t);
  
  fill(0,150,0,127);
  vertex( t,-t,-t);
  vertex( t, t,-t);
  vertex( 0, 0, t);
  
  fill(0,0,150,127);
  vertex( t, t,-t);
  vertex(-t, t,-t);
  vertex( 0, 0, t);
  
  fill(150,0,150,127);
  vertex(-t, t,-t);
  vertex(-t,-t,-t);
  vertex( 0, 0, t);
  
  endShape();
}
}

*/
