//pde x

import oscP5.*;
import netP5.*;
import papaya.*;
import java.util.*; 
import processing.video.*;
//import processing.opengl.*;
import shapes3d.*;
import shapes3d.utils.*;
import shapes3d.animation.*;

OscP5 pos_in;
OscP5 oscP5;
int lport = 12000;
int coutport = 14000;
int cinport = 14001;
int bcport = 32000;
NetAddress myLocation;
NetAddress myBroadcastLocation; 
String myprefix = "/tweez";
boolean connected = false;

PApplet APPLET = this;
Map map;
Camera cam;
Roster roster;
ArrayList<ParticleSystem>explosions = new ArrayList<ParticleSystem>();

Terrain terrain;
int X_SIZE = 1001;
int Z_SIZE = 1001;

int TERRAIN_SLICES = 25;
float TERRAIN_HORIZON = 500;
float TERRAIN_AMP = 70;

String[] laserTex = new String[] {
  "laser1.jpg", "laser2.jpg", "laser3.JPG", "laser4.jpg",
};

String[] terrainTex = new String[] {//textures for terrain
  "floor1.jpg", "floor2.gif", "floor3.jpg", "floor4.jpg", "floor5.jpg", "floor6.jpg", "floor7.jpg","floor8.jpg","floor9.jpg"
};

String[] skyTex = new String[] {//could load fog as background
  "sky1.jpg", "sky2.jpg", "sky3.jpg", "sky4.jpg", "sky5.jpg", "sky6.jpg", "sky7.jpg", "sky8.jpg", "sky9.jpg"
};
String[] fireTex = new String[] {
  "fire1.jpg"
};
String[] glassTex = new String[] {
  
};
String[] waterTex = new String[] {
  
};
String earthTex = new String[] {
  
};



PImage laserTexCur;
PImage terrainTexCur;
PImage skyTexCur;

//PShader lines;
//PShader noise;
//PShader noise2;
//PShader lasershader;
//PShader lasershader2;


PVector acc = new PVector(0, 0, 0); //can we set Camera directly from OSC?
PVector joystick = new PVector(0, 0, 0);



void setup() 
{
  smooth();
  size(500,500, P3D);
  frameRate(24);
  
  pos_in = new OscP5(this, cinport);
  pos_in.plug(this, "accelData", "/nunchuck/accel");
  pos_in.plug(this, "joystickData", "/nunchuck/joystick");
  
  oscP5 = new OscP5(this,lport);
  
  myLocation = new NetAddress("127.0.0.1", coutport);
<<<<<<< HEAD
  myBroadcastLocation = new NetAddress("169.254.92.149", bcport);
=======
  myBroadcastLocation = new NetAddress("169.254.174.206", bcport);
>>>>>>> FETCH_HEAD
  
  initTextures();
  
  roster = new Roster();
  map = new Map(1001, 1001);
  cam = new Camera(this);
  terrain = new Terrain(APPLET, TERRAIN_SLICES, X_SIZE, TERRAIN_HORIZON);
  terrain.usePerlinNoiseMap(-TERRAIN_AMP, TERRAIN_AMP, 2.125f, 2.125f);
  terrain.drawMode(Terrain.TEXTURE);
  terrain.setTexture(terrainTexCur, TERRAIN_SLICES);
  terrain.cam = cam.cam;
  
  //lines = loadShader("linesfrag.glsl");
  //noise = loadShader("noisefrag.glsl");
  //noise2 = loadShader("noisefrag2.glsl");
  //lasershader = loadShader("potentiallaserfrag.glsl");
  //lasershader2 = loadShader("potentiallaserfrag2.glsl");
  
}
void newPlayer(){
  OscMessage np = new OscMessage(myprefix + "/newPlayer");
  np.add(1); 
 
  oscP5.send(np, myLocation); 
  println("New Player");
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
    lights(); //unneccessary, this just calls the default.
    //lines.set("time", (float) millis() * .001);
    //lines.set("bin", 10.0);
    //noise.set("time", (millis() * .001));
    //noise.set("time", (cam.pos.y * -.001));
    //noise.set("resolution", (float) width, (float) height); //these values reproduce the site's effect
    //shader(gridcolors);
    map.display();
    terrain.draw();
    //resetShader();
    
    //println("pos", cam.pos);
    //println("eye", cam.cam.eye());
    
    cam.display();
    PSDisplay();
    cam.look(acc.x, acc.y);
    cam.move(joystick);
    PVector next = adjustY(PVector.add(cam.pos, cam.move), terrain, 0);
    if (map.checkBounds(next) == -1)
    { 
      cam.update();
      cam.adjustToTerrain(terrain, -30); //should be fine, because it only alters the eye, which is overwritten by pos. gottabe after update for that reason. if you wanted to update pos, or an object, use Terrain.adjustPosition.
      sendPos(cam.pos.x, 0, cam.pos.z, 0, cam.rot.y, 0);
    }
    else
    {
      println("boundary!", cam.pos);
      cam.move(new PVector(0, 0, 0));
    }
  }
  
  
}

public void joystickData(int x, int z) 
{
  if (joystick != null)
  {
    joystick.z = (z == 127) ? 0 : z;
    joystick.x = (x == 95) ? 0 : x;
    joystick.z = map(constrain(x, 0, 256), 0, 256, -1, 1); //resting 127
    joystick.x = map(constrain(z, -32, 220), -32, 220, -1, 1); //resting 95
    //println("joystick called!", joystick);
    joystick.x *= 1.5;
    joystick.y *= 1.5;
  }
}

public void accelData(int x, int y, int z) 
{ 
    if (acc != null);
    {
      acc.x = ((x < -30) && (x >= 30)) ? 0 : x;
      acc.y = ((y < 120) && (y >= 40)) ? 0 : y;
    
      acc.x = map(constrain(x, -70, 70), -70, 70, -1, 1); //resting 0
      acc.y = map(constrain(y, 30, 127), 30, 127, -1, 1); //resting 95
      acc.z = map(constrain(y, 30, 150), 30, 150, -1, 1); //we don't use this
      //println("accel called!", acc);
      acc.x *= -2.0;
      acc.y *= -6.0; //this should be a "set" value for height, rather than an "increment"
    }
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
    connected = true; //ought to be another message that just sets this.
    String iprefix = theOscMessage.get(0).stringValue();
    if (roster.isMe(iprefix)) {return;}
    roster.add(iprefix); //function checks "isin"
    roster.print();
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
  
  if (messageaddr.equals("/chuck/init"))
  {
    loop();
    if (randomSpawnCamera(5000) == -1)
    {
      cam.living = false; 
      sendKill(myprefix, myLocation);
      sendKill(myprefix, myBroadcastLocation);
      println("chaos reigns!");
    }
  }
  
  if (messageaddr.equals("/object") && messagetag.equals("ffffffs"))
  {
    float ix = theOscMessage.get(0).floatValue();
    float iy = theOscMessage.get(1).floatValue();
    float iz = theOscMessage.get(2).floatValue();
    float irx = theOscMessage.get(3).floatValue();
    float iry = theOscMessage.get(4).floatValue();
    float irz = theOscMessage.get(5).floatValue();
    String itype = theOscMessage.get(6).stringValue();
    
    if (itype.equals("obelisk")) 
    { 
      PVector ivec = adjustY(new PVector(ix, iy, iz), terrain, iy);
      O3DObelisk iobject = new O3DObelisk(ivec, new PVector(irx, iry, irz), new PVector(random(20, 60), random(160, 250), random(20, 60)));  
      map.add(iobject); 
    }
    else if (itype.equals("cone")) 
    { 
      PVector ivec = adjustY(new PVector(ix, iy, iz), terrain, iy);
      O3DCone iobject = new O3DCone(ivec, new PVector(irx, iry, irz), new PVector(20, 200, 70)); 
      map.add(iobject); 
    }
    else if (itype.equals("spire")) 
    { 
      PVector ivec = adjustY(new PVector(ix, iy, iz), terrain, iy);
      PVector isize = new PVector(random(50, 90), random(150, 250), random(50, 90)); 
      Spire iobject = new Spire(ivec, new PVector(irx, iry, irz), isize); 
      map.add(iobject); 
    }
    else { println("recieved bad object type"); }
    
  }
  
  if (isin != -1)
  {
    Player iplayer = roster.players.get(isin);
    String iaddr = roster.removePrefix(messageaddr);
    
    if (iaddr.equals("/shot") && messagetag.equals("ffffff"))
    {
      //println("###2 received an osc message with addrpattern "+the.addrPattern()+" and typetag "+theOscMessage.typetag());
      //the.print();
        float ipx = theOscMessage.get(0).floatValue();
        float ipy = theOscMessage.get(1).floatValue();
        float ipz = theOscMessage.get(2).floatValue();
        float ix = theOscMessage.get(3).floatValue();
        float iy = theOscMessage.get(4).floatValue();
        float iz = theOscMessage.get(5).floatValue();
        
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
      sendKill(is, myLocation);
      if (is.equals(myprefix)) 
      {
        cam.living = false;
        //noLoop; //crashed shit
        //killCamera(); //crashed shit
      }
      else //everything below should be encapsulated.
      {
        int indx = roster.indexFromPrefix(is);
        if (indx != -1)
        {
          Player player = roster.players.get(indx);
          Avatar avatar = player.avatar;
          if (map.remove(avatar) != -1)
          {
            ParticleSystem ps = new ParticleSystem();
            ps.addParticles(50, avatar.p);
            explosions.add(ps);
            println("player "+player+" has been killed");
            avatar = null;
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
        
        PVector ip = new PVector(ix, iy, iz); //ignore lookheight
        PVector ir = new PVector(irx, iry, irz); //don't rotate avatar
        
        if (map.objects.indexOf(iplayer.avatar) == -1) //if player does not have an avatar in the map.
        {
          int HEIGHT_OFFSET = 50;
          PVector ivec = adjustY(new PVector(ix, iy, iz), terrain, HEIGHT_OFFSET);
          PVector isize = new PVector(random(50, 90), random(150, 250), random(50, 90));  
          Avatar ia = new Avatar(iplayer, ivec, new PVector(0, 0, 0), isize);
          iplayer.avatar = (map.add(ia) != -1) ? ia : null; 
          //if avatar is successfully added to the map, else set player's avatar pointer to null.
          //println("model:", iplayer.avatar.getModelApex());
        }
        else
        {
          int HEIGHT_OFFSET = 50;
          PVector ivec = adjustY(new PVector(ix, iy, iz), terrain, HEIGHT_OFFSET);
           map.move(iplayer.avatar, ivec, new PVector(0, 0, 0));
           //println("model:", iplayer.avatar.getModelApex());
        }

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

void sendShot(PVector ipos, PVector iaim, NetAddress ilocation)
{
  OscMessage ocoor = new OscMessage(myprefix + "/shot");
  ocoor.add(ipos.x);
  ocoor.add(ipos.y);
  ocoor.add(ipos.z);
  ocoor.add(iaim.x);
  ocoor.add(iaim.y);
  ocoor.add(iaim.z);
  oscP5.send(ocoor, ilocation);
}

void sendKill(String iaddr, NetAddress ilocation)
{
  OscMessage oaddr = new OscMessage(myprefix + "/kill");
  oaddr.add(iaddr);
  oscP5.send(oaddr, ilocation);
  
}

void keyPressed()
{
  switch(key)
  {
    case 'C': disconnect(lport, myprefix); connect(lport, myprefix); break;
    case 'f': disconnect(lport, myprefix); connected = false; break;
    case 'R': roster.print(); break;
    case 'M': map.print(); break;
    case 'I': loop(); randomSpawnCamera(5000); break;
    case 'v': cam.living = false; sendKill(myprefix, myLocation); sendKill(myprefix, myBroadcastLocation); break; //cam.living = false; killCamera(); (myprefix); break;
    
    //temp testing variables
    case 'w': joystick.x = 2; break;
    case 'x': joystick.x = -2; break;
    case 'a': joystick.z = -2; break;
    case 'd': joystick.z = 2; break;
    case 's': joystick.x = 0; joystick.z = 0; break;
    
    case 'j': acc.x = -1; break;
    case 'k': acc.x = 0; acc.y = 0; break;
    case 'l': acc.x = 1; break;
    case 'u': acc.y = 1; break;
    case 'm': acc.y = -1; break;
<<<<<<< HEAD
    case 'p': newPlayer(); break;
=======

>>>>>>> FETCH_HEAD
    
    case 'z':
    {
      if (shoot(cam.pos, cam.aim) == -1) { println( "in' blanks" ); }
      break;
    }
  }
}

int randomSpawnCamera(int tries) 
{
  for (int i = 0; i <= tries; i++)
  {
    PVector pvec = new PVector(random( -(map.xsize / 2), (map.xsize / 2) ), 0, random( -(map.zsize / 2), (map.zsize / 2) ));
    pvec = adjustY(pvec, terrain, 0);
    PVector rvec = new PVector(0, 0, 0);
    if (map.checkBounds(pvec) == -1)
    {
      println("pvec", pvec);
      cam.spawnCamera(pvec.get(), rvec);
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
  text("Scream!", width/2, height/2);
}

int shoot(PVector pos, PVector aim)
{
  int indx = map.getIndexByAngle(pos, aim);
  sendShot(pos, aim, myLocation);
  sendShot(pos, aim, myBroadcastLocation);
  if (indx != -1)
  { 
    if (map.objects.get(indx).getType().equals("avatar"))
    {
      Avatar a =  (Avatar) map.objects.get(indx);
      println("killed player "+a.player.prefix+"");
      sendKill(a.player.prefix, myBroadcastLocation);
      map.remove(a); //remove when we recieve word from the hive //maybe if this is jumpy, fuck it later.
      ParticleSystem ps = new ParticleSystem();
      ps.addParticles(50, a.p);
      explosions.add(ps);
      a.player.avatar = null; //good place to implement a "Player isLiving"
      return indx;
    }
  }
  return -1;
}

PVector adjustY(PVector ipv, Terrain it)
{
  PVector opv = ipv.get();
  it.adjustPosition(opv, Terrain.WRAP);
  float oy = it.getHeight(opv.x, opv.z);
  opv.y = oy;
  return opv;
}

PVector adjustY(PVector ipv, Terrain it, float ihover)
{
  PVector opv = ipv.get();
  it.adjustPosition(opv, Terrain.WRAP);
  float oy = it.getHeight(opv.x, opv.z) + ihover; //keep in mind this is gonna want a negative value.
  opv.y = oy;
  return opv;
}

void initTextures()
{
  laserTexCur = loadImage( laserTex[ (int) random(0, laserTex.length) ] );
  skyTexCur = loadImage( laserTex[ (int) random(0, laserTex.length) ] );
  terrainTexCur = loadImage( laserTex[ (int) random(0, laserTex.length) ] );
}

void PSDisplay()
{
  for (int i = 0; i < explosions.size(); i++)
  {
    ParticleSystem explosion = explosions.get(i);
    explosion.update();
    if (explosion.size > 0)
    {
      explosion.draw();
    }
    else
    {
      explosions.remove(i);
    }
  }
}
