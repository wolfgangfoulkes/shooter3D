class Object3D 
{
  PVector p = new PVector(0, 0, 0); //defaults so janky data is visible
  PVector r = new PVector(0, 0, 0);
  PVector radius = new PVector(100, 100);
  //String tag;
  //int tagno
  
  Object3D (PVector ip, PVector ir)
  {
    p = ip;
    r = ir;
  }
  
  Object3D (float ix, float iy, float iz, float ixr, float iyr, float izr)
  {
    p = new PVector(ix, iy, iz);
    r = new PVector(ixr, iyr, izr);
  }
  
  Object3D (float ix, float iy, float iz, float ixr, float iyr, float izr, float iradius)
  {
    p = new PVector(ix, iy, iz);
    r = new PVector(ixr, iyr, izr);
    radius = new PVector(iradius, iradius);
  }
  
  Object3D (PVector ip, PVector ir, PVector iradius)
  {
    p = ip;
    r = ir;
    radius = iradius;
  }
  
  void display()
  {
    stroke(2);
    fill(100, 100, 100);
    pushMatrix();
    translate(p.x, p.y, p.z);
    rotateY(radians(r.x)); //to radians
    rotateX(radians(r.y));
    rotateZ(radians(r.z));
    rectMode(CENTER);
    box(80, 80, 80);
    //println(modelX(0, 0, 0), modelY(0, 0, 0), modelZ(0, 0, 0));
    popMatrix();
    //noStroke();
    //noFill();
  }
  
  void update()
  {
  }
  
  void startMoveTo (PVector ip)
  {
    p = ip; 
  }
  
  void startRotTo (PVector ir)
  {
  }
  
  void destroy() 
  {
  }
  
  String getType()
  {
    return "object";
  }
}
