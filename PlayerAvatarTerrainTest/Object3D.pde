class Object3D 
{
  PVector p; //= new PVector(0, 0, 500); //defaults so janky data is visible
  PVector r; //= new PVector(0, 0, 0);
  float radius; //= 100;
  //String tag;
  //int tagno
  
  Object3D (PVector ip, PVector ir)
  {
    p = ip;
    r = ir;
    radius = 100;
  }
  
  Object3D (float ix, float iy, float iz, float ixr, float iyr, float izr)
  {
    p = new PVector(ix, iy, iz);
    r = new PVector(ixr, iyr, izr);
    radius = 100;
  }
  
  Object3D (float ix, float iy, float iz, float ixr, float iyr, float izr, float iradius)
  {
    p = new PVector(ix, iy, iz);
    r = new PVector(ixr, iyr, izr);
    radius = iradius;
  }
  
  Object3D (PVector ip, PVector ir, float iradius)
  {
    p = ip;
    r = ir;
    radius = iradius;
  }
  
  void move()
  {
  }
  
  void update()
  {
  }
  
  void display()
  {
    stroke(2);
    fill(100, 100, 100);
    pushMatrix();
    translate(p.x, p.y, p.z);
    rotateX(radians(r.x)); //to radians
    rotateY(radians(r.y));
    rotateZ(radians(r.z));
    rectMode(CENTER);
    box(80, 80, 80);
    //println(modelX(0, 0, 0), modelY(0, 0, 0), modelZ(0, 0, 0));
    popMatrix();
    //noStroke();
    //noFill();
  }
  
  
  void startMoveTo (PVector ip)
  {
    p = ip; 
  }
  
  void startRotTo (PVector ir)
  {
    r = ir;
  }
  
  void setTex()
  {
  }
  
  void adjustPosition(Terrain t)
 {
   t.adjustPosition(p, Terrain.WRAP);
 } 
  
  void destroy() 
  {
    //explosion animation goes here.
  }
  
  String getType()
  {
    return "object";
  }
  
  Shape3D getShape()
  {
    return null;
  }
}
