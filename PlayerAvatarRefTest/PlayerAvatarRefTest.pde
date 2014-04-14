
import oscP5.*;
import netP5.*;

OscP5 oscP5;
Map map;

int lport = 12000;
int bcport = 32000;
//bool isConnected = false; //this or a manually-called connection function, otherwise we must always run broadcaster first

NetAddress myBroadcastLocation; 
Roster roster = new Roster();
ArrayList<NetAddress>myRemoteLocations = new ArrayList<NetAddress>(0);

void setup() {
  size(400,400);
  frameRate(25);

  oscP5 = new OscP5(this,lport);
  myBroadcastLocation = new NetAddress("169.254.76.33",bcport);
  connect(lport);
  //connect(lport + 1);
}


void draw() {
  background(0);
}

void connect(int ilport) //should do all this crap automatically before players "spawn" because we ought to have bugs in this worked out before players are allowed to see anything
{
  OscMessage m = new OscMessage("/server/connect");
  m.add(ilport); 
  oscP5.send(m, myBroadcastLocation);
}

void keyPressed() 
{
  OscMessage m = new OscMessage("/player/move");
  if (key == '+') 
  {
    m.add( new PVector(.1, .1, .1).array() );
    for (int i = 0; i < roster.players.size(); i++)
    {
      NetAddress oaddr = roster.players.get(i).getNetAddress();
      oscP5.send(m, oaddr);
    }
  }
  else if (key == '_')
  {
    m.add( new PVector(-.1, -.1, -.1).array() );
    for (int i = 0; i < roster.players.size(); i++)
    {
      NetAddress oaddr = roster.players.get(i).getNetAddress();
      oscP5.send(m, oaddr);
    }
  }
  else return;
}

void oscEvent(OscMessage theOscMessage) 
{
  println("### receivedc an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
  
  String messageIP = theOscMessage.netaddress().address();
  int messageport = theOscMessage.netaddress().port();
  String messageaddr = theOscMessage.addrPattern();
  String messagetag = theOscMessage.typetag();
  int isin = roster.indexFromNA(messageIP, messageport);

   //player initialization message. 
  if (messageaddr.equals("/players/add")) //remember this fucking string functions you fucking cunt don't fuck up and fucking == with two strings.
  {
    String iIP = theOscMessage.get(0).stringValue();
    int iport = theOscMessage.get(1).intValue();
    roster.add(iIP, iport); //function checks "isin"
    roster.print();
    return;
  }
  
  //player removal message
  if (messageaddr.equals("/players/remove")) //remember this fucking string functions you fucking cunt don't fuck up and fucking == with two strings.
  {
    String iIP = theOscMessage.get(0).stringValue();
    int iport = theOscMessage.get(1).intValue();
    roster.remove(iIP, iport);
    return;
  }
  
  if (isin != -1)
  {
    if (messageaddr.equals("/spawn")) {} //don't implement for now
    else if (messageaddr.equals("/player/move")) //should be /posrot with 6 values 
    {
      //update via Roster
      //then assure those changes are synced with Map //if this is not handled within roster //the only condition where it wouldn't be synced via the reference would be creation/destruction
      PVector ip = new PVector(0, 0, 0);
      PVector ir = new PVector(0, 0, 0);
      
      ip.x = theOscMessage.get(0).floatValue();
      ip.y = theOscMessage.get(1).floatValue();
      ip.z = theOscMessage.get(2).floatValue();
      
      //ir.x = theOscMessage.get(3).floatValue();
      //ir.y = theOscMessage.get(4).floatValue();
      //ir.z = theOscMessage.get(5).floatValue();
      
      Player player = roster.players.get(isin);
      if (player.avatar == null)
      {
        player.initAvatar(ip, ir); //should be encapsulated in player
      }
      else
      {
        player.setAvatar(ip, ir);
        println("Avatar moves", player.avatar.p, player.avatar.p);
      }
    }
    else if (messageaddr.equals("/destroy")) {} //don't implement for now;
    
    println("smelt it", messageIP);
  }
  else
  {
    println("she doesn't even go here..", messageIP);
  }
}
