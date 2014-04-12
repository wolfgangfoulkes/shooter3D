class Roster
{
  ArrayList<Player>players;
  
  Roster()
  {
    players = new ArrayList<Player>(0);
  }
  
  int add(int ilp, String iIP)
  {
    int isin = indexFromIP(iIP);
    if (isin == -1)
    {
      players.add(new Player(ilp, iIP));
    }
    return isin;
  }
  
  int remove(int ilp, String iIP)
  {
    int indx = indexFromIP(iIP);
    if (indx != -1)
    {
      players.remove(indx);
    }
    return indx;
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
}
