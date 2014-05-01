class Spire extends Object3D
//if the top vertex is (0, 0, height), then all other vertexes are just the shape (tri, square) that the bottom will be.
//first, make this variable, and add the other Object3D functionality,
//next, get it into Processing and texture it according to the tutorial,
//then add chance.

//use PVectors for the vertex stuff
//use switches to make the number of sides variable (start with 3-4. add 5 if that doesn't take long)

//note: use disableStyle() to recolor PShapes on the fly.

//could normalize 0-1, and then scale, but I fucked it up once, so later-later. OH! it's because scaling is done in %
//so convert first and you're fine. again: later.

//making the apex(0, 0, 0) will help the radius problems, because it'll be the center of translation. or, to fix it, use the values/2 to center it at center. later.
{
  PShape spire;
  PVector apex, a, b, c, modelapex, modela, modelb, modelc;
  
  Spire(PVector ip, PVector ir, PVector isize)
  {
    super(ip, ir, isize);
    type = "spire";
    spire = createShape();
    
    apex = new PVector(random(0, 1), -1, -random(0, 1)); //(new PVector(.5, 0, .5))
    a = new PVector(0, 0, 0); //might've been smarter to make the apex 0. later. 
    b = new PVector(1, 0, -random(0, 1)); 
    c = new PVector(random(0, 1), 0, -1); 

    spire.beginShape(TRIANGLES);
    textureMode(NORMAL);
    spire.vertex(a.x, a.y, a.z, 0, 0); //0 - (1, 0, 0)
    spire.vertex(b.x, b.y, b.z, 1, 0); 
    spire.vertex(apex.x, apex.y, apex.z, .5, 1);
    
    spire.vertex(a.x, a.y, a.z , 0, 0); //0 - (0, 0, 1)
    spire.vertex(c.x, c.y, c.z, 1, 0);
    spire.vertex(apex.x, apex.y, apex.z, .5, 1);
    
    spire.vertex(b.x, b.y, b.z, 0, 0);
    spire.vertex(c.x, c.y, c.z, 1, 0); //(1, 0, 0) - (0, 0, 1)
    spire.vertex(apex.x, apex.y, apex.z, .5, 1);
    spire.endShape(CLOSE);
    
    pushMatrix();
    translate(p.x, p.y, p.z); //keep in mind you're adjusting around (0, 0)
    rotateY(radians(r.y)); //don't quote me on this.
    scale(size.x, size.y, size.z);
    translate(-.5, 0, .5); //center axis. 
    modelapex = new PVector(modelX(apex.x, apex.y, apex.z), modelY(apex.x, apex.y, apex.z), modelZ(apex.x, apex.y, apex.z));
    modela = new PVector(modelX(a.x, a.y, a.z), modelY(a.x, a.y, a.z), modelZ(a.x, a.y, a.z));
    modelb = new PVector(modelX(b.x, b.y, b.z), modelY(b.x, b.y, b.z), modelZ(b.x, b.y, b.z));
    modelc = new PVector(modelX(c.x, c.y, c.z), modelY(c.x, c.y, c.z), modelZ(c.x, c.y, c.z));
    popMatrix();
    
    
    spire.setTexture(terrainTexCur);
    spire.setTint(color(255, 255, 255, 200));
    spire.setStroke(0);
  }
  
  void display()
  {
    pushMatrix();
    translate(p.x, p.y, p.z); //keep in mind you're adjusting around (0, 0)
    //rotateY(radians(r.y)); //don't quote me on this.
    scale(size.x, size.y, size.z);
    translate(-.5, 0, .5); //center axis. 
    
    shape(spire);
    popMatrix();
  }
  
  void set(PVector ip, PVector ir)
  {
    super.set(ip, ir);
    
    pushMatrix();
    translate(p.x, p.y, p.z); //keep in mind you're adjusting around (0, 0)
    //rotateY(radians(r.y)); //don't quote me on this.
    scale(size.x, size.y, size.z);
    translate(-.5, 0, .5); //center axis. 
    modelapex = new PVector(modelX(apex.x, apex.y, apex.z), modelY(apex.x, apex.y, apex.z), modelZ(apex.x, apex.y, apex.z));
    modela = new PVector(modelX(a.x, a.y, a.z), modelY(a.x, a.y, a.z), modelZ(a.x, a.y, a.z));
    modelb = new PVector(modelX(b.x, b.y, b.z), modelY(b.x, b.y, b.z), modelZ(b.x, b.y, b.z));
    modelc = new PVector(modelX(c.x, c.y, c.z), modelY(c.x, c.y, c.z), modelZ(c.x, c.y, c.z));
    popMatrix();
  }
  
  void adjustToTerrain(Terrain iterrain)
  {
    adjustY(p, iterrain);
  }
  
  void setTex(PImage texture, int tint)
  {
    spire.setTexture(texture);
    spire.setTint(color(255, 255, 255, tint));
  }
  
  Shape3D getShape()
  {
    return null;
  }
}
