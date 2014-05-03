class Spire extends Object3D
//if the top vertex is (0, 0, height), then all other vertexes are just the shape (tri, square) that the bottom will be.
//first, make this variable, and add the other Object3D functionality,
//next, get it into Processing and texture it according to the tutorial,
//then add chance.

//could have apex be (0, 0, 0), then set size AFTER generating shape (!)
//could call modelX in the constructor? Idunno it seems to be a buggy function.
//could easily just initialize it with the scaled coordinates.
{
  PShape spire;
  PVector apex, a, b, c;
  
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
    
    spire.setTexture(terrainTexCur);
    spire.setTint(color(255, 255, 255, 200));
    spire.setStroke(0);

    println("vertex: ", spire.getVertex(0), spire.getVertex(1), spire.getVertex(2));
  }
  
  void display()
  {
    pushMatrix();
    translate(p.x, p.y, p.z); //keep in mind you're adjusting around (0, 0)
    //rotateY(radians(r.y)); //don't quote me on this.
    scale(size.x, size.y, size.z);
    translate(-.5, 0, .5); //center axis. 
    //could just make apex the center of rotation, because rotation isn't applied to this object.
    //that'd mean the position + height would be the apex. radius wouldn't be quite right.
    //test it, and if it works, great!
    shape(spire);
    popMatrix();
  }
  
  void set(PVector ip, PVector ir)
  {
    super.set(ip, ir);
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
  
  
  PVector getApex()
  {
    return new PVector((apex.x * size.x) + p.x, (apex.y * size.y) + p.y, (apex.z * size.z) + p.z);
    //(p.x - size/2) + (apex.x * size.x), p.y + (apex.y * size.y) + p.y, (p.z - size/2) + (apex.z * size.z) 
  } 
  
}
