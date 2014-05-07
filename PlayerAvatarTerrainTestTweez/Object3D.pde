class Object3D 
//base class for storage in MAP. put dummies for functions that would need to be called
//from the MAP or on several objects here.
{
  PVector p;
  PVector r;
  PVector size = new PVector(0, 0, 0);
  float radius;
  String type;
  int isLiving = 1;

  
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
    type = "object";
  }
  
  Object3D (float ix, float iy, float iz, float ixr, float iyr, float izr, PVector isize)
  {
    p = new PVector(ix, iy, iz);
    r = new PVector(ixr, iyr, izr);
    size = isize;
    radius = max(size.x, size.z) / 2;
    type = "object";
  }
  
  Object3D (PVector ip, PVector ir, PVector isize)
  {
    p = ip;
    r = ir;
    size = isize;
    radius = max(size.x, size.z) / 2;
    type = "object";
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
