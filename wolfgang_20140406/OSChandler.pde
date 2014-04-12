class OSCHandler
{
  int lport;
  OscP5 oscP5;
  NetAddress myBroadcastLocation; 
  ArrayList<Player> players;
  
  OSCHandler(String bcIPin, int bcportin, int lportin)
  {
    lport = lportin;
    oscP5 = new OscP5(this, lport);
    myBroadcastLocation = new NetAddress(bcIPin, bcportin);
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
