class Player
{
  String prefix;
  Avatar avatar;
  
  Player(String iprefix)
  {
    prefix = iprefix;
    avatar = null;
  }
  
  void initAvatar(PVector ip, PVector ir, PVector isize)
  {
    avatar = new Avatar(this, ip, ir, isize);
    //isAlive = true;
  }
  
  void setAvatar(PVector ip, PVector ir, PVector isize) //should be merged with above
  {
    if (avatar == null) 
    { 
      initAvatar(ip, ir, isize); //then add into map?
    }
    else 
    {
      avatar.p = ip;
      avatar.r = ir;
    }
  }
  
  boolean isAlive()
  {
    if (avatar == null) {return false;}
    else {return true;}
  }
}
