class O3DObelisk extends Object3D 
//would be pretty easy to make a generic class with all the stuff the Shapes3D library has (radius, slices)
//and then extend just with the specific object, and default values.

{
  Ellipsoid obelisk;
  int nbrSl = 4;
  int nbrSg = 20;
  
  O3DObelisk(PVector ip, PVector ir, PVector isize)
  {
    super(ip, ir, isize);
    type = "obelisk";
    //nbrSl = (int) random(2, 6);
    //nbrSg = (int) random(10, 20);
    obelisk = new Ellipsoid(APPLET, nbrSl, nbrSg);
    obelisk.setRadius(isize.x / 2, isize.y / 2, isize.z / 2);
    obelisk.moveTo(p);
    obelisk.rotateToY(radians(r.y));
    obelisk.drawMode(S3D.TEXTURE);
    obelisk.setTexture(terrainTexCur);
  }
  
  O3DObelisk(float ix, float iy, float iz, float irx, float iry, float irz, PVector isize)
  {
    super(ix, iy, iz, irx, iry, irz, isize);
    type = "obelisk";
    //nbrSl = (int) random(2, 6);
    //nbrSg = (int) random(10, 20);
    obelisk = new Ellipsoid(APPLET, nbrSl, nbrSg);
    obelisk.setRadius(isize.x / 2, isize.y / 2, isize.z / 2);
    obelisk.moveTo(p);
    obelisk.rotateToY(radians(r.y));
    obelisk.drawMode(S3D.TEXTURE);
    obelisk.setTexture(terrainTexCur);
  }
  
  void set(PVector ip, PVector ir)
  {
    super.set(ip, ir);
    obelisk.moveTo(p);
    obelisk.rotateToY(radians(r.y));
  }
  
  /*
  void moveTo(PVector ip, PVector ir)
  {
    move = ip;
    r = ir;
  }
  */
  
  
  void update() //this'll cause more rather than fewer problems. movements will be small enough at a time, that there shouldn't be an issue.
  {
  }
  
  void display()
  {
    obelisk.draw();
  }
  
  void setTex(PImage itex)
  {
    obelisk.setTexture(itex);
  }
  
  void adjustToTerrain(Terrain iterrain)
  {
    p = adjustY(p, iterrain);
    obelisk.moveTo(p);
    obelisk.rotateToY(radians(r.y));
    
  }
  
  Shape3D getShape ()
  {
    return obelisk;
  }
  
}
