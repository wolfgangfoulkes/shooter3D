
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 32000;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 12000;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

ArrayList<String>IPs = new ArrayList(0); //must send primitive values. //this object is redundant
//ArrayList<int>ports = new ArrayList(0); doesn't work? ints?

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
    connect(theOscMessage.netAddress().address());
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) 
  {
    disconnect(theOscMessage.netAddress().address());
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddressList. 
   */
  else {
    //oscP5.send(theOscMessage, myNetAddressList);
  }
}


 private void connect(String theIPaddress) 
 {
     if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) 
     {
       myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
       IPs.add(theIPaddress); //this object is redundant
       println("### adding "+theIPaddress+" to the list.");
       
       OscMessage olist = new OscMessage("/players/add");
       if (IPs.size() > 0)
        {
          olist.add(IPs.toArray());
          oscP5.send(olist, myNetAddressList);
        }
     } 
     else 
     {
       println("### "+theIPaddress+" is already connected.");
     }
     
     println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
 }



private void disconnect(String theIPaddress) 
{
  
  if (myNetAddressList.contains(theIPaddress, myBroadcastPort)) 
  {
  		myNetAddressList.remove(theIPaddress, myBroadcastPort);
    println("### removing "+theIPaddress+" from the list.");
    
    OscMessage ostring = new OscMessage("players/remove");
    ostring.add(theIPaddress);
    oscP5.send(ostring, myNetAddressList);
  } 
  else 
  {
    println("### "+theIPaddress+" is not connected.");
  }
  
  println("### currently there are "+myNetAddressList.list().size());
}
