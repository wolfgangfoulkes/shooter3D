class Map
{
  ArrayList<Object3D> objects;
  
  Map()
  {
    objects = new ArrayList<Object3D>();
  }  
   void Map2()
  {
    //objects2 = new ArrayList<Object3D2>();
  }  
  
  void display()
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      objects.get(i).display();
    }
  }
  
  int checkBounds(PVector icoord)
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      //println("distance", PVector.dist(icoord, oobject.p));
      if (Math.abs(icoord.x) >= 1080.0 || Math.abs(icoord.z) >= 1080.0) { println("arena bounds!"); return i; }
      if (PVector.dist(icoord, oobject.p) <= oobject.radius) //((oobject.p.x == icoord.x) && (oobject.p.y == icoord.y) && (oobject.p.z == icoord.z))
      {        
        return i; 
      }
    }  
    return -1;
  }
  
  int checkBounds(float ix, float iy, float iz)
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      PVector icoord = new PVector(ix, iy, iz);
      if (Math.abs(icoord.x) >= 1080.0 || Math.abs(icoord.z) >= 1080.0) { println("arena bounds!"); return i; }
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
  
  
  Object3D getCoord(float ix, float iy, float iz)
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      if ((oobject.p.x == ix) && (oobject.p.y == iy) && (oobject.p.z == iz))
      {
        return oobject;
      }
    }  
    return null;
  }
  
  Object3D getCoord(PVector icoord)
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      if (oobject.p == icoord) //((oobject.p.x == icoord.x) && (oobject.p.y == icoord.y) && (oobject.p.z == icoord.z))
      {
        return oobject;
      }
    }  
    return null;
  }
  

  int destroy(PVector ipos, PVector iaim) //need to check null up in here.
  {
    int shotEm = -1; 
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      PVector vec1 = PVector.sub(iaim, ipos);
      PVector vec2 = PVector.sub(objects.get(i).p, ipos);
      float vecangle = degrees(PVector.angleBetween(vec1, vec2));
      if (vecangle < 10)
      {
        objects.get(i).destroy(); 
        objects.remove(i);
        shotEm = 1;
      }
    }
  
  return shotEm;
  }
}
