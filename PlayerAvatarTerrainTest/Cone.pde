class O3DCone extends Object3D 
//would be pretty easy to make a generic class with all the stuff the Shapes3D library has (radius, slices)
//and then extend just with the specific object, and default values.

{
  Cone cone;
  PVector apex;
  int nbrSg = 20;

  O3DCone(PVector ip, PVector ir, PVector isize)
  {
    super(ip, ir, isize);
    type = "cone";
    cone = new Cone(applet, nbrSg);
    cone.setSize(isize.x / 2, isize.z / 2, isize.y);
    cone.moveTo(p);
    cone.rotateToY(radians(r.y));
    cone.drawMode(S3D.TEXTURE);
    cone.setTexture(terrainTexCur);
    apex = new PVector(p.x, p.y + isize.y, p.z);
    
    
  }
  
  O3DCone(float ix, float iy, float iz, float irx, float iry, float irz, PVector isize)
  {
    super(ix, iy, iz, irx, iry, irz, isize);
    type = "cone";
    cone = new Cone(applet, nbrSg);
    cone.setSize(isize.x / 2, isize.z / 2, isize.y);
    cone.moveTo(p);
    cone.rotateToY(radians(r.y));
    cone.drawMode(S3D.TEXTURE);
    cone.setTexture(terrainTexCur);
    apex = new PVector(p.x, p.y + isize.y, p.z);
  }
  
  void set(PVector ip, PVector ir)
  {
    super.set(ip, ir);
    cone.moveTo(p);
    cone.rotateToY(radians(r.y));
    apex = new PVector(p.x, p.y + size.y, p.z);
  }
  
  void update() //this'll cause more rather than fewer problems. movements will be small enough at a time, that there shouldn't be an issue.
  {
  }
  
  void display()
  {
    cone.draw();
  }
  
  void setTex(PImage itex)
  {
    cone.setTexture(itex);
  }
  
  void adjustToTerrain(Terrain iterrain)
  {
    p = adjustY(p, iterrain);
    cone.moveTo(p);
    cone.rotateToY(radians(r.y));
    apex = new PVector(p.x, p.y + size.y, p.z);
  }
  
  Shape3D getShape ()
  {
    return cone;
  }
  
}
