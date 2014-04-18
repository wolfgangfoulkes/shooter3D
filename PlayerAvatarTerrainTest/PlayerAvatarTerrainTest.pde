import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;


import oscP5.*;
import netP5.*;

OscP5 pos_in;
OscP5 oscP5;
Map map;
Camera cam;

int lport = 12000;
int bcport = 32000;
String myprefix = "/slurp";

NetAddress myBroadcastLocation; 
Roster roster;

PVector acc = new PVector(0, 0, 0); //can we set Camera directly from OSC?
PVector joystick = new PVector(0, 0, 0);

void setup() 
{
  smooth();
  size(500,500, P3D);
  frameRate(24);
  
  pos_in = new OscP5(this, 1234);
  pos_in.plug(this, "accelData", "/nunchuck/accel");
  pos_in.plug(this, "joystickData", "/nunchuck/joystick");
  
  oscP5 = new OscP5(this,lport);
  myBroadcastLocation = new NetAddress("169.254.47.210",bcport);
  //connect(lport, myprefix);
  
  roster = new Roster();
  map = new Map(1001, 1001);
  
  //have these initialized by spawn, because you'll display the noLoop screen here anyway.
  cam = new Camera(this);
}

void draw() 
{
  background(0);
  lights();
  
  if(cam.living == false)
  {
    killCamera();
    noLoop(); 
  }
  
  cam.cam.camera();
  cam.look(acc.x, 0, 100);
  map.display();
  
  if (map.checkBounds(PVector.add(cam.pos, joystick)) == -1)
  {
    cam.move(joystick);
    sendPos(cam.pos.x, cam.pos.y, cam.pos.z);
  }
  else
  {
    cam.move(PVector.sub(new PVector(0, 0, 0), joystick));
    cam.move(new PVector(0, 0, 0));
    println("boundary!", cam.pos);
  }
}

public void joystickData(int x, int z) 
{
    joystick.x = map(constrain(x, -10, 10), -10, 10, -1, 1); //need to be -1 - 1 //you had a small typo here that was probably causing all kinda havok
    joystick.z = map(constrain(z, -10, 10), -10, 10, -1, 1);
    println("joystick called!", joystick);
}

public void accelData(int x, int y, int z) 
{ 
    acc.x = map(constrain(x, -10, 10), -10, 10, -1, 1); //needs to be -1 - 1
    acc.y = map(constrain(y, -10, 10), -10, 10, -1, 1); 
    acc.z = map(constrain(z, -10, 10), -10, 10, -1, 1);
    println("accel called!", acc);

 }

void connect(int ilport, String ipre) //should do all this crap automatically before players "spawn" because we ought to have bugs in this worked out before players are allowed to see anything
{
  OscMessage m = new OscMessage("/server/connect");
  m.add(ilport); 
  m.add(ipre);
  oscP5.send(m, myBroadcastLocation);
}

void disconnect(int ilport, String ipre)
{
  roster.clear();
  map.clear();
  OscMessage m = new OscMessage("/server/disconnect");
  m.add(ilport); 
  m.add(ipre);
  oscP5.send(m, myBroadcastLocation);
}

void oscEvent(OscMessage theOscMessage) 
{
  //println("###2 received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  //theOscMessage.print();
  
  String messageIP = theOscMessage.netaddress().address();
  String messageaddr = theOscMessage.addrPattern();
  String messagetag = theOscMessage.typetag();
  int isin = roster.indexFromAddrPattern(messageaddr); //this could be the only check function, because "begins with" is the same as "equals"

  //player initialization message. 
  if (messageaddr.equals("/players/add")) //remember this fucking string functions you fucking cunt don't fuck up and fucking == with two strings.
  {
    String iprefix = theOscMessage.get(0).stringValue();
    if (roster.isMe(iprefix)) {return;}
    roster.add(iprefix); //function checks "isin"
    //roster.print();
    return;
  }
  
  //player removal message
  if (messageaddr.equals("/players/remove")) //remember this fucking string functions you fucking cunt don't fuck up and fucking == with two strings.
  {
    String iprefix = theOscMessage.get(0).stringValue();
    int rosterindx = roster.indexFromPrefix(iprefix);
    if ( rosterindx == -1 || iprefix.equals(myprefix) ) { return; } //isme/isn't in there.
    else 
    {
      Player iplayer = roster.players.get(rosterindx);
      map.remove(iplayer.avatar); //checks "isin" so null won't throw
      roster.remove(iprefix); //function checks "isin"
    }
    
    //roster.print();
    return;
  }
  
  if (messageaddr.equals("/object") && messagetag.equals("ffffff"))
  {
    float ix = theOscMessage.get(0).floatValue();
    float iy = theOscMessage.get(1).floatValue();
    float iz = theOscMessage.get(2).floatValue();
    float irx = theOscMessage.get(3).floatValue();
    float iry = theOscMessage.get(4).floatValue();
    float irz = theOscMessage.get(5).floatValue();
    Object3D iobject = new Object3D(ix, iy, iz, irx, iry, irz);
    map.add(iobject);
  }
  
  if (isin != -1)
  {
    Player iplayer = roster.players.get(isin);
    String iaddr = roster.removePrefix(messageaddr);
    
    //a player was spawned
    if (iaddr.equals("/init") && messagetag.equals("fff")) //"ffffff" //this is redundant and confusing.
    {
      float ix = theOscMessage.get(0).floatValue();
      float iy = theOscMessage.get(1).floatValue();
      float iz = theOscMessage.get(2).floatValue();
      
      PVector ip = new PVector(ix, iy, iz);
      Avatar ia = new Avatar(iplayer, ip, new PVector(0, 0, 0));
      if (map.objects.contains(iplayer.avatar))
      {
        map.objects.remove(iplayer.avatar);
        iplayer.avatar = null;
      }
      
      if (map.add(ia) != -1)
      {
        iplayer.avatar = ia;
      }
      else 
      { 
        println("avatar was not initialized at position: "+ip+""); 
      } //the shit that'll not be in sync will be the Players. 
      //println(iplayer.prefix, iaddr, ix, iy, iz);
    }
    
    //a player has been killed
    else if (iaddr.equals("/kill") && messagetag.equals("s"))
    {
      String is = theOscMessage.get(0).stringValue();
      if (is.equals(myprefix)) {}
      else //everything below should be encapsulated.
      {
        int indx = roster.indexFromPrefix(is);
        if (indx != -1)
        {
          Object3D object = roster.players.get(indx).avatar;
          if (map.remove(object) != -1)
          {
            //object = null; //does this work? call map first ofcourse.
            roster.players.get(indx).avatar = null;
          }
        }
      }
    }
    
    //player positions, currently updated at draw-rate (could be just at change))
    else if (iaddr.equals("/pos") && messagetag.equals("fff"))
    {
      float ix = theOscMessage.get(0).floatValue();
      float iy = theOscMessage.get(1).floatValue();
      float iz = theOscMessage.get(2).floatValue();
      
      PVector ip = new PVector(ix, iy, iz);
      if (map.move(iplayer.avatar, ip) != -1)
      {
        println("the avatar of "+iplayer.prefix+" was moved to "+ip+"");
      }
      else 
      {
        println("the avatar of "+iplayer.prefix+" was not moved to "+ip+"");
      }
      
    }
    }
    
    else
    {
      //println("she doesn't even go here..", messageaddr);
    }
}


void sendInit(float ix, float iy, float iz) //+ rotation
{
  OscMessage ocoor = new OscMessage(myprefix + "/init");
  ocoor.add(ix);
  ocoor.add(iy);
  ocoor.add(iz);
  oscP5.send(ocoor, myBroadcastLocation);
}

void sendPos(float ix, float iy, float iz) //+ rotation
{
  OscMessage ocoor = new OscMessage(myprefix + "/pos");
  ocoor.add(ix);
  ocoor.add(iy);
  ocoor.add(iz);
  oscP5.send(ocoor, myBroadcastLocation);
}

void sendKill(String iaddr)
{
  OscMessage oaddr = new OscMessage(myprefix + "/kill");
  oaddr.add(iaddr);
  oscP5.send(oaddr, myBroadcastLocation);
}


void keyPressed()
{
  switch(key)
  {
    case 'c': disconnect(lport, myprefix); connect(lport, myprefix); break;
    case 'f': disconnect(lport, myprefix); break;
    case 'r': roster.print(); break;
    case 'm': map.print(); break;
    case 'i': loop(); randomSpawnCamera(5000); sendInit(cam.pos.x, cam.pos.y, cam.pos.z); break;
    case 'v': noLoop(); cam.living = false; killCamera(); sendKill(myprefix); break;
    
    //temp testing variables
    case 'w': joystick.x = 2; break;
    case 'x': joystick.x = -2; break;
    case 'a': joystick.z = 2; break;
    case 'd': joystick.z = -2; break;
    case 's': joystick.x = 0; joystick.z = 0; break;
    
    case 'j': acc.x = .5; break;
    case 'k': acc.x = 0; break;
    case 'l': acc.x = -.5; break;
    
    case 'z':
    {
      int indx = map.getIndexByAngle(cam.pos, PVector.add(cam.pos, cam.look));
      if (indx != -1) { map.objects.remove(indx); }
      break;
    }
  }
}


int randomSpawnCamera(int tries) //this null-returning function is more dangerous than just calling this thing wherever it's used.
{
  for (int i = 0; i <= tries; i++)
  {
    PVector pvec = new PVector(random( -(map.xsize / 2), (map.xsize / 2) ), 0, random( -(map.zsize / 2), (map.zsize / 2) ));
    PVector rvec = new PVector(0, 0, 0);
    if (map.checkBounds(pvec) == -1)
    {
      cam.spawnCamera(pvec, rvec);
      return 0;
    }
  }
  
  return -1;
}

void killCamera()
{
  background(50);
  camera();
  textAlign(CENTER);
  textSize(50);
  fill(100, 0, 0);
  text("Scream, Jailbait!", width/2, height/2);
}


