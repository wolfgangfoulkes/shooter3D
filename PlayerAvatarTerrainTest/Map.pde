class Map
{
  float xsize;
  float zsize;
  ArrayList<Object3D> objects;
  
  float terrainSize = 500;
  int gridSlices = 25;
  float horizonDraw = 200;
  Terrain terrain;
  //should add items to terrain whenever they're added to Map, etc.
  
  Map(float ixs, float izs)
  {
    xsize = ixs;
    zsize = izs;
    objects = new ArrayList<Object3D>(0);
    
    terrain = new Terrain(applet, 16, xsize, 500);
    terrain.usePerlinNoiseMap(-30, 30, 2.125f, 2.125f);
    terrain.setTexture(terrainTex[(int)random(0, terrainTex.length)], 16);
    terrain.tag = "Ground"; //why?
    terrain.tagNo = -1; //why?
    terrain.drawMode(S3D.TEXTURE);
  }
  
  int add(Object3D iobject) //type-check to include "?" right now.
  {
    int isIn = objects.indexOf(iobject);
    PVector ip = adjustY(iobject.p, terrain, iobject.p.y);
    int isInBounds = checkBounds(ip);
    if ( (isIn == -1) && (isInBounds == -1) )
    {
      iobject.set(ip, iobject.r);
      objects.add(iobject);
      println("p", iobject.p);
      
      //?object.addToTerrain?
      //Shape3D ishape = iobject.getShape();
      //if (ishape != null) { terrain.addShape(ishape); }
      return 0;
    }
    
    return -1;
  }
  
  int remove(Object3D iobject)
  {
    int indexof = objects.indexOf(iobject);
    //Shape3D ishape = iobject.getShape(); //throws an exception. perhaps put it in the if block?
    if (indexof != -1)
    {
      //if (ishape != null) { terrain.removeShape(ishape); }
      objects.remove(iobject);
      return indexof;
    }
    
    return -1;
  }
  
  void clear()
  {
    objects.clear();
  }
  
  int move(Object3D iobject, PVector ipos, PVector irot)
  {
    int iindx = this.remove(iobject);
    int isInBounds = checkBounds(ipos);
    if ( (iindx != -1) ) //janky as shit.
    {
      iobject.set(ipos, irot);
      this.add(iobject); //adjusts to terrain.
      return iindx;
    }
    else 
    {
      return -1;
    }
  }
  
  void display()
  {
    terrain.draw();
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D object = objects.get(i);
      //object.update() //these would apply given some force that needed time-based application, or given we decided to update only on changing position.
      //object.adjustToTerrain()
      object.display();
    }
  }
  
  int checkBounds(PVector icoord) //this function may be the cause of many of our problems
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      if (PVector.dist(icoord, oobject.p) <= oobject.radius)
      {        
        //println("object:", oobject.p);
        return i; 
      }
    }  
    return -1;
  }
  
  int checkBounds(float ix, float iy, float iz)
  {
    PVector icoord = new PVector(ix, iy, iz);
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      if (PVector.dist(icoord, oobject.p) <= oobject.radius)
      {
        return i;
      }
    }  
    return -1;
  }
  
  
  int checkCoord(PVector icoord)
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      if (oobject.p == icoord) 
      {
        return i;
      }
    }  
    return -1;
  }
 
 
  int checkCoord(float ix, float iy, float iz)
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      if ((oobject.p.x == ix) && (oobject.p.y == iy) && (oobject.p.z == iz))
      {
        return i;
      }
    }  
    return -1;
  }
  
  int getIndexByAngle(PVector ipos, PVector iaim) 
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      PVector vec1 = PVector.sub(iaim, ipos);
      PVector vec2 = PVector.sub(objects.get(i).p, ipos);
      float vecangle = degrees(PVector.angleBetween(vec1, vec2));
      if (vecangle <= 5)
      {
        return i;
      }
    }
    return -1;
  }
  
  void randomObjects(int many)
  {
    for (int i = 0; i < many; i++)
    {
      Object3D robject = new Object3D(random(-(xsize/2), xsize/2), 0, random(-(zsize/2), zsize/2), 0, 0, 0);
      add(robject);
    }
  }
  
  void setCamera(TerrainCam icam)
  {
    terrain.cam = icam;
  }
  
  void setTexture(String ifiles[]) //this could be a global function.
  {
    terrain.drawMode(S3D.TEXTURE);
    terrain.setTexture(ifiles[(int) random(0, ifiles.length)], 16);
  }
  
  void print()
  {
    println("-----MAP-----");
    println("size = "+objects.size()+"");
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      println("object at index "+i+": type = "+oobject.getType()+", position = "+oobject.p+", rotation = "+oobject.r+"");
    }
  }
}
