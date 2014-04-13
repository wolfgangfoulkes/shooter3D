
import oscP5.*;
import netP5.*;

OscP5 oscP5;
int myListeningPort = 32000;
int myBroadcastPort = 12000;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect"; 

ArrayList<String>IPs = new ArrayList(0); //must send primitive values
//could replace the NetAddress array with an array of tags and net addresses.

void setup() {
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(25);
}

void draw() {
  background(0);
}

void oscEvent(OscMessage theOscMessage) {
  OscMessage IPout = new OscMessage("/players");
  if (theOscMessage.addrPattern().equals(myConnectPattern)) {
    if (connect(theOscMessage.netAddress().address()));
    {
      IPout.add(IPs.toArray());
      for (int i = 0; i < IPs.size(); i++)
      {
        oscP5.send(IPout, new NetAddress(IPs.get(i), myBroadcastPort));
      }
    }
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) {
    if (disconnect(theOscMessage.netAddress().address()))
    {
      //need to remove name, which means I need to store names with IP's. fuck.
        IPout.add(IPs.toArray());
        for (int i = 0; i < IPs.size(); i++)
        {
          oscP5.send(IPout, new NetAddress(IPs.get(i), myBroadcastPort));
        }
        
    }
  }
  /**
   * if !(connect || disconnect), then broadcast the incoming
   * message to all addresses in the netAddressList. 
   */
  for (int i = 0; i < IPs.size(); i++)
   {
     oscP5.send(IPout, new NetAddress(IPs.get(i), myBroadcastPort));
   }
}


 private boolean connect(String theIPaddress) {
     boolean newAdd;
     if (!IPs.contains(theIPaddress)) {
       IPs.add(theIPaddress);
       newAdd = true;
       println("### adding "+theIPaddress+" to the list.");
     } else {
       newAdd = false;
       println("### "+theIPaddress+" is already connected.");
     }
     println("### currently there are "+IPs.size()+" remote locations connected.");
     return newAdd;
 }



private boolean disconnect(String theIPaddress) {
boolean existingplayer;
if (IPs.contains(theIPaddress)) {
    IPs.remove(theIPaddress);
    existingplayer = true;
       println("### removing "+theIPaddress+" from the list.");
     } else {
       existingplayer = false;
       println("### "+theIPaddress+" is not connected.");
     }
     println("### currently there are "+IPs.size());
     return existingplayer;  
 }
