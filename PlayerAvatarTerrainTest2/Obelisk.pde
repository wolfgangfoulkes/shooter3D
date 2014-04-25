class O3DObelisk extends Object3D 
//would be pretty easy to make a generic class with all the stuff the Shapes3D library has (radius, slices)
//and then extend just with the specific object, and default values.

{
  Ellipsoid obelisk;
  int nbrSl = 4;
  int nbrSg = 20;
  String tag;
  int tagno;
  
  O3DObelisk(PApplet pa, PVector ip, PVector ir, float iradius)
  {
    super(ip, ir, iradius);
    obelisk = new Ellipsoid(pa, nbrSl, nbrSg);
    obelisk.setRadius(radius * 1, radius * .5, radius * 1);
    //obelisk.drawMode(S3D.TEXTURE);
    //we'll do "addShape" within the Map class on the whole array, using the "getEllipsoid" method
  }
  
  O3DObelisk(PApplet pa, float ix, float iy, float iz, float irx, float iry, float irz, float iradius)
  {
    super(ix, iy, iz, irx, iry, irz, iradius);
    obelisk = new Ellipsoid(pa, nbrSl, nbrSg);
    obelisk.setRadius(radius * 1, radius * .5, radius * 1);
    //obelisk.drawMode(S3D.TEXTURE);
  }
  
  
  /*
  void moveTo(PVector ip, PVector ir)
  {
    p = ip;
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
    obelisk.moveTo(p);
    obelisk.rotateToY(radians(r.y));
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
    obelisk.adjustToTerrain(iterrain, Terrain.WRAP, 30);
    p = obelisk.getPosVec();
  }
  
  String getType()
  {
    return "obelisk"; //should just be "object" unless there's a good reason.
  }
  
  
  Shape3D getShape ()
  {
    return obelisk;
  }
  
}
