import oscP5.*;
import netP5.*;
import papaya.*;

import java.util.*; 

import processing.video.*;
import processing.opengl.*;

import shapes3d.*;
import shapes3d.utils.*;
import shapes3d.animation.*;



OscP5 pos_in;
OscP5 oscP5;
int lport = 12000;
int bcport = 32000;
NetAddress myBroadcastLocation; 
String myprefix = "/slurp";
boolean connected = false;

PApplet applet = this;
Map map;
Camera cam;
Roster roster;
//Terrain terrain;

PVector acc = new PVector(0, 0, 0); //can we set Camera directly from OSC?
PVector joystick = new PVector(0, 0, 0);

String[] laserTex = new String[] {
  "laser1.jpg", "laser2.jpg", "laser3.JPG", "laser4.jpg",
};

String[] terrainTex = new String[] {//textures for terrain
  "floor1.jpg", "floor2.gif", "floor3.jpg", "floor4.jpg", "floor5.jpg", "floor6.jpg", "floor7.jpg","floor8.jpg","floor9.jpg"
};

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
  cam = new Camera(this);
  map.setCamera(cam.cam);
  map.setTexture(terrainTex);
  
}

void draw() 
{
  if ( (cam.living == false) || (connected == false) )
  {
    background(0);
    killCamera();
    noLoop(); 
  }
  else
  {
    background(0);
    lights();
  
    map.display();
    cam.display();
    cam.look(acc.x, acc.y);
    cam.move(joystick);
    
    if (map.checkBounds(PVector.add(cam.pos, cam.move)) == -1) 
    { 
      cam.update();
      cam.adjustToTerrain(map.terrain, 10); //should be fine, because it only alters the eye, which is overwritten by pos. gottabe after update for that reason. if you wanted to update pos, or an object, use Terrain.adjustPosition.
      sendPos(cam.pos.x, cam.pos.y, cam.pos.z, 0, cam.rot.y, 0);
    }
    else
    {
      //cam.move(PVector.mult(cam.look, -1));
      println("boundary!", cam.pos);
    }
  }
  
}

public void joystickData(int x, int z) 
{
    joystick.x = map(constrain(x, -10, 10), -10, 10, -1, 1); //need to be -1 - 1 //you had a small typo here that was probably causing all kinda havok
    joystick.z = map(constrain(z, -10, 10), -10, 10, -1, 1);
    //println("joystick called!", joystick);
}

public void accelData(int x, int y, int z) 
{ 
    acc.x = map(constrain(x, -10, 10), -10, 10, -1, 1); //needs to be -1 - 1
    acc.y = map(constrain(y, -10, 10), -10, 10, -1, 1); 
    acc.z = map(constrain(z, -10, 10), -10, 10, -1, 1);
    //println("accel called!", acc);

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
    O3DObelisk iobject = new O3DObelisk(applet, ix, iy, iz, irx, iry, irz, 100.0);
    map.add(iobject);
  }
  
  if (isin != -1)
  {
    Player iplayer = roster.players.get(isin);
    String iaddr = roster.removePrefix(messageaddr);
    
    if (iaddr.equals("/shot") && messagetag.equals("fff"))
    {
      //println("###2 received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
      //theOscMessage.print();
        float ix = theOscMessage.get(0).floatValue();
        float iy = theOscMessage.get(1).floatValue();
        float iz = theOscMessage.get(2).floatValue();
        
        Avatar a = iplayer.avatar;
        if (a != null) 
        {
          a.startLaser(new PVector(ix, iy, iz));
        }
    }
    
    //a player has been killed
    if (iaddr.equals("/kill") && messagetag.equals("s"))
    {
      //println("###2 received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
      //theOscMessage.print();
      String is = theOscMessage.get(0).stringValue();
      if (is.equals(myprefix)) 
      {
        cam.living = false;
        //noLoop; 
        //killCamera(); //crashed shit
      }
      else //everything below should be encapsulated.
      {
        int indx = roster.indexFromPrefix(is);
        if (indx != -1)
        {
          Avatar object = roster.players.get(indx).avatar;
          for (int i = 0; i < 50; i++)
          {
            println(object.player.prefix);
          }
          if (map.remove(object) != -1)
          {
            for (int i = 0; i < 50; i++)
            {
              println("removed object!");
            }
            //object = null; //does this work? call map first ofcourse.
            roster.players.get(indx).avatar = null;
          }
        }
      }
    }
    
    //player positions, currently updated at draw-rate (could be just at change))
    else if (iaddr.equals("/pos") && messagetag.equals("ffffff"))
    {
        float ix = theOscMessage.get(0).floatValue();
        float iy = theOscMessage.get(1).floatValue();
        float iz = theOscMessage.get(2).floatValue();
        float irx = theOscMessage.get(3).floatValue();
        float iry = theOscMessage.get(4).floatValue();
        float irz = theOscMessage.get(5).floatValue();
        
        PVector ip = new PVector(ix, iy, iz);
        PVector ir = new PVector(irx, iry, irz);
        
        if (iplayer.avatar != null)
        {
          int indx = map.move(iplayer.avatar, ip, ir);
          if (indx == -1) {iplayer.avatar = null;}
        }
        /*
        Avatar ia = new Avatar(iplayer, ip, ir);
        if (map.objects.contains(iplayer.avatar)) 
        {
          map.objects.remove(iplayer.avatar); //should use a map.move function instead that does checks.
          iplayer.avatar = null; //redundant(?)
        }
        
        if (map.add(ia) != -1)
        {
          iplayer.avatar = ia;
        }
        */
    
  }
}
}

void sendPos(float ix, float iy, float iz, float irx, float iry, float irz) //+ rotation
{
  OscMessage ocoor = new OscMessage(myprefix + "/pos");
  ocoor.add(ix);
  ocoor.add(iy);
  ocoor.add(iz);
  ocoor.add(irx);
  ocoor.add(iry);
  ocoor.add(irz);
  oscP5.send(ocoor, myBroadcastLocation);
}

void sendShot(PVector iaim)
{
  OscMessage ocoor = new OscMessage(myprefix + "/shot");
  ocoor.add(iaim.x);
  ocoor.add(iaim.y);
  ocoor.add(iaim.z);
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
    case 'C': disconnect(lport, myprefix); connect(lport, myprefix); connected = true; break;
    case 'f': disconnect(lport, myprefix); connected = false; break;
    case 'R': roster.print(); break;
    case 'M': map.print(); break;
    case 'I': loop(); randomSpawnCamera(5000); break;
    case 'v': cam.living = false; sendKill(myprefix); break; //cam.living = false; killCamera(); sendKill(myprefix); break;
    
    //temp testing variables
    case 'w': joystick.x = 2; break;
    case 'x': joystick.x = -2; break;
    case 'a': joystick.z = -2; break;
    case 'd': joystick.z = 2; break;
    case 's': joystick.x = 0; joystick.z = 0; break;
    
    case 'j': acc.x = -.5; break;
    case 'k': acc.x = 0; acc.y = 0; break;
    case 'l': acc.x = .5; break;
    case 'u': acc.y = .5; break;
    case 'm': acc.y = -.5; break;
    
    case 'z':
    {
      if (shoot(cam.pos, PVector.mult(cam.look, 1000)) == -1) { println( "shootin' blanks" ); }
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
  background(80, 0, 0);
  camera();
  textAlign(CENTER);
  textSize(50);
  fill(100, 100, 100);
  text("Scream, Jailbait!", width/2, height/2);
}

int shoot(PVector pos, PVector aim)
{
  int indx = map.getIndexByAngle(pos, aim);
  sendShot(aim);
  if (indx != -1)
  { 
    if (map.objects.get(indx).getType().equals("avatar"))
    {
      Avatar a =  (Avatar) map.objects.get(indx);
      println("killed player "+a.player.prefix+"");
      sendKill(a.player.prefix);
      map.remove(a); //remove when we recieve word from the hive //maybe if this is jumpy, fuck it later.
      a = null; //good place to implement a "Player isLiving"
      return indx;
    }
  }
  return -1;
}


