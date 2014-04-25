class Object3D 
//base class for storage in MAP. put dummies for functions that would need to be called
//from the MAP or on several objects here.
{
  PVector p;
  PVector r;
  float radius;
  String type;

  
  Object3D (PVector ip, PVector ir)
  {
    p = ip;
    r = ir;
    radius = 100;
    type = "object";
  }
  
  Object3D (PVector ip, PVector ir, String itype)
  {
    p = ip;
    r = ir;
    radius = 100;
    type = itype;
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
  
  void set(PVector ip, PVector ir)
  {
    p = ip;
    r = ir;
  }
  
  void moveTo(PVector imove)
  {
    //move = imove;
  }
  
  void startMoveTo (PVector imove)
  {
    //move = imove;
  }
  
  void startRotTo (PVector imove)
  {
  }
  
  
  void update()
  {
  }
  
  void display()
  {
    //I leave this crap here, so we can tell when the base class has had display called.
    stroke(2);
    fill(100, 100, 100);
    pushMatrix();
    translate(p.x, p.y, p.z);
    rotateX(radians(r.x)); //to radians
    rotateY(radians(r.y));
    rotateZ(radians(r.z));
    rectMode(CENTER);
    box(80, 80, 80);
    popMatrix();
  }
  
  void adjustToTerrain(Terrain t)
   {
   } 
 
   void setTex()
   {
   }
  
  void destroy() 
  {
    //explosion animation goes here.
  }
  
  String getType()
  {
    return type;
  }
  
  Shape3D getShape()
  {
    return null;
  }
}
