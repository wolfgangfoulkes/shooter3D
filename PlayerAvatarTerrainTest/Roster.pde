class Roster
{
  ArrayList<Player>players;
  
  Roster()
  {
    players = new ArrayList<Player>(0);
  }
  
  int add(String ipre)
  {
    int isin = indexFromPrefix(ipre);
    if (isin == -1)
    {
      players.add(new Player(ipre));
    }
    return isin;
  }
  
  int remove(String ipre)
  {
    int indx = indexFromPrefix(ipre);
    if (indx != -1)
    {
      players.remove(indx);
    }
    return indx;
  }
  
  void clear ()
  {
    players.clear();
  }
  
  boolean isMe(String ipre)
  {
    if (ipre.equals(myprefix)) return true;
    else return false;
  }
  
  int indexFromPrefix(String ipre)
  {
    for(int i = 0; i < players.size(); i++)
    {
      Player p = players.get(i);
      if (ipre.equals(p.prefix))
      {
        return i;
      }
    }
    return -1;
  }
  
  int indexFromAddrPattern(String iaddr)
  {
    for(int i = 0; i < players.size(); i++)
    {
      Player p = players.get(i);
      if (iaddr.startsWith(p.prefix))
      {
        return i;
      }
    }
    
    return -1;
  }
  
  
  String removePrefix(String iaddr)
  {
    for(int i = 0; i < players.size(); i++)
    {
      Player p = players.get(i);
      if (iaddr.startsWith(p.prefix))
      {
        String ostring = iaddr.substring(p.prefix.length(), iaddr.length()); //-1 to remove the last parenthesis
        return ostring;
      }
    }
    
    return iaddr;
  }
  
  void print()
  {
    println("-----ROSTER-----1");
    println("size = "+players.size()+"");
    for (int i = 0; i < players.size(); i++)
    {
      Player player = players.get(i);
      println("player"+i+":", "prefix = "+player.prefix+"");
      if (player.avatar != null) {player.avatar.print();} else {println("no avatar");}
    }
  }
}
