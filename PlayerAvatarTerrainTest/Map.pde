class Map
{
  float xsize;
  float zsize;
  ArrayList<Object3D> objects;
  //Terrain terrain;
  //should add items to terrain whenever they're added to Map, etc.
  
  Map(float ixs, float izs)
  {
    xsize = ixs;
    zsize = izs;
    objects = new ArrayList<Object3D>(0);
  }
  
  int add(Object3D iobject) //type-check to include "isIn?" right now.
  {
    int isIn = objects.indexOf(iobject);
    int isInBounds = checkBounds(iobject.p);
    if ( (isIn == -1) && (isInBounds == -1) )
    {
      objects.add(iobject);
      return 0;
    }
    
    return -1;
  }
  
  int remove(Object3D iobject)
  {
    int indexof = objects.indexOf(iobject);
    if (indexof != -1)
    {
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
    int iindx = objects.indexOf(iobject);
    int isInBounds = checkBounds(ipos);
    if ( (iindx != -1) && (isInBounds == iindx) ) 
    {
      Object3D object = objects.get(iindx);
      object.p = ipos;
      object.r = irot;
      return iindx;
    }
    else 
    {
      return -1;
    }
  }
  
  void display()
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      objects.get(i).display();
    }
  }
  
  int checkBounds(PVector icoord) //this function may be the cause of many of our problems
  {
    if (Math.abs(icoord.x) > ( xsize / 2 ) || Math.abs(icoord.z) > ( zsize / 2 )) 
    { println("map bounds!"); return 0; }
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      if (PVector.dist(icoord, oobject.p) <= oobject.radius)
      //temporary solution
      {        
        return i; 
      }
    }  
    return -1;
  }
  
  int checkBounds(float ix, float iy, float iz)
  {
    PVector icoord = new PVector(ix, iy, iz);
    if (Math.abs(icoord.x) >= ( xsize / 2 ) || Math.abs(icoord.z) >= ( zsize / 2 )) 
    { println("map bounds!"); return 0; }
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
      if (oobject.p == icoord) //((oobject.p.x == icoord.x) && (oobject.p.y == icoord.y) && (oobject.p.z == icoord.z))
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
  
  int getIndexByAngle(PVector ipos, PVector iaim) //this function needs to be rewritten. 
  //solution might be multiplying the look by the distance between the two points, or normalizing that second angle.
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
