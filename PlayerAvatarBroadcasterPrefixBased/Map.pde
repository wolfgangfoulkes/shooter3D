class Map
{
  float xsize;
  float zsize;
  ArrayList<Object3D> objects;
  
  Map(float ixs, float izs)
  {
    xsize = ixs;
    zsize = izs;
    objects = new ArrayList<Object3D>(0);
  }
  
  int add(Object3D iobject)
  {
    int isIn = objects.indexOf(iobject);
    PVector ip = iobject.p.get();
    int isInBounds = checkBounds(ip);
    if ( (isIn == -1) && (isInBounds == -1) )
    {
      iobject.set(ip, iobject.r);
      objects.add(iobject);
      //println("p", iobject.p);
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
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D object = objects.get(i);
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
      Object3D robject = new Object3D(random(-(xsize/2), xsize/2), random(50, 80), random(-(zsize/2), zsize/2), 0, 0, 0);
      robject.type = (random(0, 1) > .5) ? "spire" : "cone";
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
