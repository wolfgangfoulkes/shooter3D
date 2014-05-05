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
  
  int add(Object3D iobject) //type-check to include "?" right now.
  {
    int isIn = objects.indexOf(iobject);
    int isInBounds = checkBounds(iobject.p);
    if ( (isIn == -1) && (isInBounds == -1) )
    {
      objects.add(iobject);
      println(iobject.p, iobject.r, iobject.radius);
      
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
      shader(noise2);
      Object3D object = objects.get(i);
      object.display();
      resetShader();
    }
    
  }
  
  int checkBounds(PVector icoord) //this function may be the cause of many of our problems
  {
    for (int i = objects.size() - 1; i >= 0; i--)
    {
      Object3D oobject = objects.get(i);
      PVector ic = new PVector(icoord.x, 0, icoord.z);
      PVector oc = new PVector(oobject.p.x, 0, oobject.p.z);
      if (PVector.dist(ic, oc) <= oobject.radius)
      {
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
      PVector ic = new PVector(icoord.x, 0, icoord.z);
      PVector oc = new PVector(oobject.p.x, 0, oobject.p.z);
      if (PVector.dist(ic, oc) <= oobject.radius)
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
      vec1.y = 0;
      vec2.y = 0;
      //could individually check the xz angles (using vector2s) and the xyz angle and xz would be less forgiving.
      float vecangle = degrees(PVector.angleBetween(vec1, vec2));
      if (vecangle <= 9)
      {
        return i;
      }
    }
    return -1;
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