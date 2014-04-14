class Player
{
  String prefix;
  Avatar avatar;
  
  Player(String iprefix)
  {
    prefix = iprefix;
    avatar = null;
    println("new Player! prefix "+prefix+"");
  }
  
  void initAvatar(PVector ip, PVector ir)
  {
    avatar = new Avatar(this, ip, ir);
  }
  
  void setAvatar(PVector ip, PVector ir) //should be merged with above
  {
    if (avatar == null) 
    { 
      avatar = new Avatar(this, ip, ir); //then add into map?
    }
    else 
    {
      avatar.p = ip;
      avatar.r = ir;
    }
  }
}
