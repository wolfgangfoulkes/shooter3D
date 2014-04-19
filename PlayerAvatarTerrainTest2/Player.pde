class Player
{
  String prefix;
  Avatar avatar;
  //boolean isAlive;
  
  Player(String iprefix)
  {
    prefix = iprefix;
    avatar = null;
    //isAlive = false;
    println("new Player! prefix "+prefix+"");
  }
  
  void initAvatar(PVector ip, PVector ir)
  {
    avatar = new Avatar(this, ip, ir);
    //isAlive = true;
  }
  
  void setAvatar(PVector ip, PVector ir) //should be merged with above
  {
    if (avatar == null) 
    { 
      initAvatar(ip, ir); //then add into map?
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
