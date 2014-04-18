class Clientlist
{
  ArrayList<Client>clients;
  
  Clientlist()
  {
    clients = new ArrayList<Client>(0);
  }
  
  int indexFromIP(String iIP)
  {
    for(int i = 0; i < clients.size(); i++)
    {
      Client c = clients.get(i);
      if (c.IP.equals(iIP))
      {
        return i;
      }
    }
    return -1;
  }
  
  int indexFromPrefix(String ipre)
  {
    for(int i = 0; i < clients.size(); i++)
    {
      Client c = clients.get(i);
      if (c.prefix.equals(ipre))
      {
        return i;
      }
    }
    return -1;
  }
  
  void clear()
  {
    clients.clear();
  }
  
  void print()
  {
    for (int i = 0; i < clients.size(); i++)
    {
      Client c = clients.get(i);
      println("client"+i+":", "IP = "+c.IP+"", "port = "+c.port+"", "prefix = "+c.prefix+"");
    }
  }
}
  
  
