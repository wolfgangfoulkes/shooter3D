class Map
{
  ArrayList<Object3D> objects;
  //ArrayList<Object3D2> objects2;
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
  
  int removeCoord(float ix, float iy, float iz)
  {
    int indx = this.checkCoord(ix, iy, iz);
    if (indx != -1)
    {
      objects.remove(indx);
      return indx;
    }
    else 
    {
      return -1;
    }
  }
  
  int destroy(PVector ipos, PVector iaim)
  {
    int shotEm = -1; 
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      PVector vec1 = PVector.sub(iaim, ipos);
      PVector vec2 = PVector.sub(objects.get(i).p, ipos);
      float vecangle = degrees(PVector.angleBetween(vec1, vec2));
      if (vecangle < 10)
      {
       // println(objects.get(i).p, objects.get(i).r);
        objects.remove(i);
        shotEm = 1;
      }
    }
  
  return shotEm;
  }
}
