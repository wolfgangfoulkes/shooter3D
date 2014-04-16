import oscP5.*;
import netP5.*;

OscP5 oscP5;
Clientlist clients = new Clientlist();
int myListeningPort = 32000;
int myBroadcastPort = 12000;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

void setup() 
{
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(25);
}

void draw() {
  background(0);
}

void oscEvent(OscMessage theOscMessage) 
{
  if (theOscMessage.addrPattern().equals(myConnectPattern)) 
  {
    String iIP = theOscMessage.netAddress().address();
    int ip = theOscMessage.get(0).intValue();
    String ipre = theOscMessage.get(1).stringValue();
    connect(iIP, ip, ipre);
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) 
  {
    String iIP = theOscMessage.netAddress().address();
    int ip = theOscMessage.get(0).intValue();
    String ipre = theOscMessage.get(1).stringValue();
    disconnect(iIP, ip, ipre);
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddressList. 
   */
  else 
  {
    sendAll(theOscMessage);
  }
  
}


 private void connect(String iIP, int ip, String ipre) 
 {
     if (clients.indexFromPrefix(ipre) == -1) //only need a new prefix, because repeat IP's are fine
     {
       clients.clients.add(new Client(iIP, ip, ipre));
       
       println("### adding "+iIP+", listening at port "+ip+" with prefix "+ipre+" to the list.");
 
       for (int i = 0; i < clients.clients.size(); i++)
       {
          OscMessage oaddr = new OscMessage("/players/add");
          Client oclient = clients.clients.get(i);
          //oaddr.add(oclient.IP);
          //oaddr.add(oclient.port);
          oaddr.add(oclient.prefix);
          sendAll(oaddr);
        }
     } 
     else 
     {
       println("### "+iIP+", listening at port "+ip+", with prefix "+ipre+" is already connected.");
     }
     
     println("### currently there are "+clients.clients.size()+" remote locations connected.");
 }


private void disconnect(String iIP, int ip, String ipre) 
{
  int rmindx = clients.indexFromPrefix(ipre);
  if (rmindx != -1) 
  {
    println("### removing "+iIP+", "+ip+", "+ipre+" from the list.");
    Client oclient = clients.clients.get(rmindx);
    OscMessage oaddr = new OscMessage("/players/remove");
    oaddr.add(oclient.prefix);
    sendAll(oaddr);
    clients.clients.remove(rmindx);
  } 
  else 
  {
    println("### "+iIP+", "+ipre+" is not connected.");
  }
  
  println("### currently there are "+clients.clients.size());
}


void sendAll(OscMessage oosc)
{
    for(int i = 0; i < clients.clients.size(); i++)
    {
      NetAddress addr = clients.clients.get(i).getNetAddress();
      oscP5.send(oosc, addr);
    }
}