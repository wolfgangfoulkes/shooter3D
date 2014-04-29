class O3DObelisk extends Object3D 
//would be pretty easy to make a generic class with all the stuff the Shapes3D library has (radius, slices)
//and then extend just with the specific object, and default values.

{
  Ellipsoid obelisk;
  int nbrSl = 4;
  int nbrSg = 20;
  String tag;
  int tagno;
  
  O3DObelisk(PVector ip, PVector ir, PVector isize)
  {
    super(ip, ir, isize);
    type = "obelisk";
    obelisk = new Ellipsoid(applet, nbrSl, nbrSg);
    obelisk.setRadius(isize.x, isize.y, isize.z);
    obelisk.moveTo(p);
    obelisk.rotateToY(radians(r.y));
    obelisk.drawMode(S3D.TEXTURE);
    obelisk.setTexture(terrainTexCur, nbrSl, nbrSg);
    obelisk.fill(color(255, 255, 255, 123));
    
  }
  
  O3DObelisk(float ix, float iy, float iz, float irx, float iry, float irz, PVector isize)
  {
    super(ix, iy, iz, irx, iry, irz, isize);
    type = "obelisk";
    obelisk = new Ellipsoid(applet, nbrSl, nbrSg);
    obelisk.setRadius(isize.x, isize.y, isize.z);
    obelisk.moveTo(p);
    obelisk.rotateToY(radians(r.y));
    obelisk.drawMode(S3D.TEXTURE);
    obelisk.setTexture(terrainTexCur, nbrSl, nbrSg);
    obelisk.fill(color(255, 255, 255, 123)); 
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
  
  void startMoveTo(PVector ip, float time, float delay) //don't know if I can consolidate this with the object structure, don't know if this lags CPU.
  {
    p = ip;
    obelisk.moveTo(ip, time, delay);
  }
  
  void startRotTo(PVector ir, float time, float delay)
  {
    r = ir;
    obelisk.rotateTo(ir, time, delay);
  }
  
  void update() //this'll cause more rather than fewer problems. movements will be small enough at a time, that there shouldn't be an issue.
  {
  }
  
  void display()
  {
    obelisk.draw();
  }
  
  void setTex(String itex)
  {
    obelisk.setTexture(itex);
  }
  
  void adjustToTerrain(Terrain iterrain)
  {
    p = adjustY(p, iterrain);
    this.update();
  }
  
  Shape3D getShape ()
  {
    return obelisk;
  }
  
}
