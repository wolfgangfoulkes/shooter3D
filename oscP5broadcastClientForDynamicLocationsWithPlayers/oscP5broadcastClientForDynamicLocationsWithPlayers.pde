/**
 * oscP5broadcastClient by andreas schlegel
 * an osc broadcast client.
 * an example for broadcast server is located in the oscP5broadcaster exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;


OscP5 oscP5;

NetAddress myBroadcastLocation; 
Roster roster = new Roster();
ArrayList<NetAddress>myRemoteLocations = new ArrayList<NetAddress>(0);

void setup() {
  size(400,400);
  frameRate(25);
  oscP5 = new OscP5(this,12000);
  myBroadcastLocation = new NetAddress("169.254.76.33",32000);
}


void draw() {
  background(0);
}


void mousePressed() {
  OscMessage myOscMessage = new OscMessage("/test");
  myOscMessage.add(100);
  for (int i = 0; i < roster.players.size(); i++)
  {
    String IPout = roster.players.get(i).IP;
    oscP5.send(myOscMessage, new NetAddress(IPout, 12000));
    println("myRemoteLocations", IPout);
  }

}


void keyPressed() {
  OscMessage m;
  switch(key) {
    case('c'):
      m = new OscMessage("/server/connect",new Object[0]);
      oscP5.flush(m,myBroadcastLocation);  
      break;
    case('d'):
      m = new OscMessage("/server/disconnect",new Object[0]);
      oscP5.flush(m,myBroadcastLocation);
      break;
  }
}


void oscEvent(OscMessage theOscMessage) 
{
  println("### receivedc an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
  if (theOscMessage.addrPattern().equals("/players")) //remember this fucking string functions you fucking cunt don't fuck up and fucking == with two strings.
  {
    for (int i = 0; i < theOscMessage.typetag().length(); i++)
    {
      roster.players.add(new Player(theOscMessage.get(i).stringValue()));
    }
  }
  else if (roster.indexFromIP(theOscMessage.netAddress().address()) != -1)
  {
    println("smelt it", theOscMessage.netAddress().address());
  }
  else
  {
    println("she doesn't even go here..");
    println(theOscMessage.netAddress().address());
  }
}
