class Roster
{
  ArrayList<Player>players;
  
  Roster()
  {
    players = new ArrayList<Player>(0);
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
