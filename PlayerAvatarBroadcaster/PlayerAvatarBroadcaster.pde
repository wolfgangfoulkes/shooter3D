
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
int myListeningPort = 32000;
int myBroadcastPort = 12000;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

void setup() {
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
    connect(iIP, ip);
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) 
  {
    //disconnect(theOscMessage.netAddress());
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddressList. 
   */
  else {
    //oscP5.send(theOscMessage, myNetAddressList);
  }
}


 private void connect(String iIP, int ip) 
 {
     if (!myNetAddressList.contains(iIP, ip)) //doesn't work checking it with a net address.
     {
       myNetAddressList.add(new NetAddress(iIP, ip));
       println("### adding "+iIP+", listening at port "+ip+" to the list.");
 
       for (int i = 0; i < myNetAddressList.list().size(); i++)
       {
          OscMessage oaddr = new OscMessage("/players/add");
          oaddr.add(myNetAddressList.get(i).address());
          oaddr.add(myNetAddressList.get(i).port());
          oscP5.send(oaddr, myNetAddressList);
        }
     } 
     else 
     {
       println("### "+iIP+", listening at port "+ip+" is already connected.");
     }
     
     println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
 }



private void disconnect(String iIP, int ip) 
{
  
  if (myNetAddressList.contains(iIP, ip)) 
  {
    myNetAddressList.remove(iIP, ip);
    println("### removing "+iIP+" from the list.");
    
    OscMessage oaddr = new OscMessage("players/remove");
    oaddr.add(iIP);
    oaddr.add(ip);
    oscP5.send(oaddr, myNetAddressList);
  } 
  else 
  {
    println("### "+iIP+" is not connected.");
  }
  
  println("### currently there are "+myNetAddressList.list().size());
}
