class O3DCone extends Object3D 
//would be pretty easy to make a generic class with all the stuff the Shapes3D library has (radius, slices)
//and then extend just with the specific object, and default values.

{
  Cone cone;
  int nbrSg = 20;
  String tag;
  int tagno;
  
  O3DCone(PApplet pa, PVector ip, PVector ir, PVector isize)
  {
    super(ip, ir, isize.x);
    type = "cone";
    cone = new Cone(pa, nbrSg);
    cone.setSize(isize.x, isize.z, isize.y);
    cone.moveTo(p);
    cone.rotateToY(radians(r.y));
    //cone.drawMode(S3D.TEXTURE);
    
  }
  
  O3DCone(PApplet pa, float ix, float iy, float iz, float irx, float iry, float irz, PVector isize)
  {
    super(ix, iy, iz, irx, iry, irz, isize.x);
    type = "cone";
    cone = new Cone(pa, nbrSg);
    cone.setSize(isize.x, isize.z, isize.y);
    cone.moveTo(p);
    cone.rotateToY(radians(r.y));
    //cone.drawMode(S3D.TEXTURE);
    
  }
  
  void set(PVector ip, PVector ir)
  {
    super.set(ip, ir);
    cone.moveTo(p);
    cone.rotateToY(radians(r.y));
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
    cone.moveTo(ip, time, delay);
  }
  
  void startRotTo(PVector ir, float time, float delay)
  {
    r = ir;
    cone.rotateTo(ir, time, delay);
  }
  
  void update() //this'll cause more rather than fewer problems. movements will be small enough at a time, that there shouldn't be an issue.
  {
  }
  
  void display()
  {
    cone.draw();
  }
  
  void setTex(String itex)
  {
    cone.setTexture(itex);
  }
  
  void adjustToTerrain(Terrain iterrain)
  {
    p = adjustY(p, iterrain);
    this.update();
  }
  
  Shape3D getShape ()
  {
    return cone;
  }
  
}
