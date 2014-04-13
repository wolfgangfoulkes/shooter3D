class Roster
{
  ArrayList<Player>players;
  
  Roster()
  {
    players = new ArrayList<Player>(0);
  }
  
  int add(String iIP, int ip)
  {
    int isin = indexFromNA(iIP, ip);
    if (isin == -1)
    {
      players.add(new Player(iIP, ip));
    }
    return isin;
  }
  
  int remove(String iIP, int ip)
  {
    int indx = indexFromNA(iIP, ip);
    if (indx != -1)
    {
      players.remove(indx);
    }
    return indx;
  }
  
  int indexFromNA(String iIP, int ip)
  {
    for(int i = 0; i < players.size(); i++)
    {
      Player p = players.get(i);
      if (p.port == ip && p.IP.equals(iIP))
      {
        return i;
      }
    }
    
    return -1;
  }
  
  int indexFromIP(String IPin)
  {
    for(int i = 0; i < players.size(); i++)
    {
      Player p = players.get(i);
      if (p.IP.equals(IPin)) //this is a fucking string function fuckwit.
      {
        return i;
      }
    }
    
    return -1;
  }
  
  void print()
  {
    for (int i = 0; i < players.size(); i++)
    {
      Player player = players.get(i);
      println("player"+i+":", "IP = "+player.IP+"", "port = "+player.port+"");
    }
  }
}
