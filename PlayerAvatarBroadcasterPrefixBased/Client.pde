class Client
{
  String IP;
  int port;
  String prefix;
  
  Client(String iIP, int ip, String ipre)
  {
    IP = iIP;
    port = ip;
    prefix = ipre;
  }
  
  NetAddress getNetAddress()
  {
    return new NetAddress(IP, port);
  }
}
