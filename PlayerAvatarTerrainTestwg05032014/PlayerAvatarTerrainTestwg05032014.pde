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
//for when you die...
PImage killScreen;
//for sky rendering
PVector camVector = new PVector(0, 0, 0);
PImage texGlobe;//can be sent to other MAC's to allow for background sync
float globeRadius = 12000;//size of world
int sDetail = 50;  // Sphere detail setting...number of triangles
float pushBack = 0;//for rendering
float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5;
int SINCOS_LENGTH = int(360.0 / SINCOS_PRECISION);
//
int lport = 12000;
int coutport = 14000;
int cinport = 14001;
int bcport = 32000;
NetAddress myLocation;
NetAddress myBroadcastLocation; 
String myprefix = "/tweez";
boolean connected = true;
//for texture syncing
int texCycle = (int)random(0,5);


PApplet APPLET = this;
Map map;
Camera cam;
Roster roster;
ArrayList<ParticleSystem>explosions = new ArrayList<ParticleSystem>();

Terrain terrain;
int X_SIZE = 1001;
int Z_SIZE = 1001;

int TERRAIN_SLICES = 16;
float TERRAIN_HORIZON = 500;
float TERRAIN_AMP = 70;


//*******Texture Arrays*******\\ 

String[] respawnTex = new String[] {
  "respawn1.png", "respawn2.png", "respawn3.png", "respawn4.png"
};
String[] laserTex = new String[] {
  "laser1.jpg", "laser2.jpg", "laser3.JPG", "laser4.jpg", "laser1.jpg", "laser2.jpg"
};
//texture order is fire/ice/glass/space/abstract repeating
String[] terrainTex = new String[] {//textures for terrain
  "lava1.jpg", "floor4.jpg", "elec1.jpg", "wires2.jpeg", "laser3.JPG", "metal1.jpg"
};

String[] skyTex = new String[] {//could load fog as background
  "laser3.JPG", "axe5.jpg", "wires1.jpg", "snow1.jpg", "fire1.jpg", "metal2.jpg"
};


PImage laserTexCur;
PImage terrainTexCur;
PImage skyTexCur;

//PShader lines;
//PShader noise;
PShader noise2;
PShader lasershader;
PShader pixel;
PShader deform;
PShader laserfire;
PShader alias;
PShader crosshair;

PVector acc = new PVector(0, 0, 0); //can we set Camera directly from OSC?
PVector joystick = new PVector(0, 0, 0);

Spire v;
///*
boolean sketchFullScreen() {
  return true;
}
//*/
void setup() 
{
  smooth();
  size(500,500, P3D);
  frameRate(24);
  //size(displayWidth, displayHeight, P3D);
  pos_in = new OscP5(this, cinport);
  pos_in.plug(this, "accelData", "/nunchuck/accel");
  pos_in.plug(this, "joystickData", "/nunchuck/joystick");
  pos_in.plug(this, "chuckRespawn", "/chuck/init");

  oscP5 = new OscP5(this, lport);

  myLocation = new NetAddress("127.0.0.1", coutport);
  myBroadcastLocation = new NetAddress("169.254.235.107", bcport);

  initTextures();
  initializeSphere(sDetail);
  roster = new Roster();
  map = new Map(1001, 1001);
  cam = new Camera(this);
  terrain = new Terrain(APPLET, TERRAIN_SLICES, X_SIZE, TERRAIN_HORIZON);
  terrain.usePerlinNoiseMap(-TERRAIN_AMP, TERRAIN_AMP, 2.125f, 2.125f);
  terrain.fill(255);
  terrainTexCur = loadImage( terrainTex[texCycle] );
  terrain.setTexture(terrainTexCur, TERRAIN_SLICES);
  terrain.drawMode(S3D.TEXTURE);
  terrain.cam = cam.cam;

  //lines = loadShader("linesfrag.glsl");
  //noise = loadShader("noisefrag.glsl");
  noise2 = loadShader("noisefrag.glsl");
  lasershader = loadShader("potentiallaserfrag.glsl");
  pixel = loadShader("pixelfrag.glsl");
  deform = loadShader("deformfrag.glsl");
  alias = loadShader("aliasingfrag.glsl");
  crosshair = loadShader("crosshairfrag.glsl");
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
    noise2.set("time", (millis() * .001));
    noise2.set("resolution", (float) width, (float) height); //these values reproduce the site's effect
    noise2.set("alpha", .95); 
    //pixel.set("pixels", 50.0, 50.0);
    //alias.set("time", millis() * .001);
    // alias.set("alpha", 1.0);
    shader(noise2);
    terrain.draw();
    map.display();
    resetShader();

    //println("pos", cam.pos);
    //println("eye", cam.cam.eye());

    cam.display();
    PSDisplay();
    cam.look(acc.x, acc.y);
    cam.move(joystick);
    renderGlobe(); 
    PVector next = adjustY(PVector.add(cam.pos, cam.move), terrain, 0);
    if (map.checkBounds(next) == -1)
    { 
      cam.update();
      cam.adjustToTerrain(terrain, -30); //should be fine, because it only alters the eye, which is overwritten by pos. gottabe after update for that reason. if you wanted to update pos, or an object, use Terrain.adjustPosition.
      //println(cam.pos);
      sendPos(cam.pos.x, 0, cam.pos.z, 0, cam.rot.y, 0);
    }
    else
    {
      println("boundary!", cam.pos);
      cam.move(new PVector(0, 0, 0));
    }
  }
}
public void chuckRespawn(int i) {
  loop();
  randomSpawnCamera(5000);
  //cam.living = true;
  newPlayer();
  println("respawn message received from Chuck");
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
    if (roster.isMe(iprefix)) {
      return;
    }
    roster.add(iprefix); //function checks "isin"

    roster.print();
    return;
  }

  //player removal message
  if (messageaddr.equals("/players/remove")) //remember this fucking string functions you fucking cunt don't fuck up and fucking == with two strings.
  {
    String iprefix = theOscMessage.get(0).stringValue();
    int rosterindx = roster.indexFromPrefix(iprefix);
    if ( rosterindx == -1 || iprefix.equals(myprefix) ) { 
      return;
    } //isme/isn't in there.
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
      O3DCone iobject = new O3DCone(ivec, new PVector(irx, iry, irz), new PVector(random(20, 90), random(90, 180), random(20, 90))); 
      map.add(iobject);
    }
    else if (itype.equals("spire")) 
    { 
      PVector ivec = adjustY(new PVector(ix, iy, iz), terrain, iy);
      PVector isize = new PVector(random(40, 90), random(150, 250), random(40, 90)); 
      Spire iobject = new Spire(ivec, new PVector(irx, iry, irz), isize); 
      map.add(iobject);
    }
    else { 
      println("recieved bad object type");
    }
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
        PVector isize = new PVector(random(20, 90), random(90, 180), random(20, 90));  
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
void newPlayer() {
  OscMessage newP = new OscMessage("/arena/newPlayer");
  newP.add(1);
  oscP5.send(newP, myLocation);
}
void sendExplosion() {
  OscMessage sendExplosion = new OscMessage(myprefix + "/explosion");
  sendExplosion.add(1);
  oscP5.send(sendExplosion, myLocation);
  println("explosion Trigger sent to Chuck");
}

void keyPressed()
{
  switch(key)
  {
  case 'C': 
    disconnect(lport, myprefix); 
    connect(lport, myprefix); 
    break;
  case 'f': 
    disconnect(lport, myprefix); 
    connected = false; 
    break;
  case 'R': 
    roster.print(); 
    break;
  case 'M': 
    map.print(); 
    break;
  case 'I': 
    loop(); 
    randomSpawnCamera(5000); 
    break;
  case 'v': 
    cam.living = false; 
    sendKill(myprefix, myLocation); 
    sendKill(myprefix, myBroadcastLocation); 
    break; //cam.living = false; killCamera(); (myprefix); break;
  case 'p': 
    newPlayer(); 
    break;
  case 'o': 
    sendExplosion(); 
    break;
    //temp testing variables
  case 'w': 
    joystick.x = 2; 
    break;
  case 'x': 
    joystick.x = -2; 
    break;
  case 'a': 
    joystick.z = -2; 
    break;
  case 'd': 
    joystick.z = 2; 
    break;
  case 's': 
    joystick.x = 0; 
    joystick.z = 0; 
    break;

  case 'j': 
    acc.x = -1; 
    break;
  case 'k': 
    acc.x = 0; 
    acc.y = 0; 
    break;
  case 'l': 
    acc.x = 1; 
    break;
  case 'u': 
    acc.y = 1; 
    break;
  case 'm': 
    acc.y = -1; 
    break;
case '[':
  initTextures();
  break;
  case 'z':
    {
      if (shoot(cam.pos, cam.aim) == -1) { 
        println( "in' blanks" );
      }
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
  camera();
  killScreen = loadImage(respawnTex[(int)random(0, respawnTex.length -1)]);
  image(killScreen, 0, 0, width, height);
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
      ps.addParticles(100, adjustY(a.p, terrain, -30));
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
{//for syncing texture changes

    texGlobe = loadImage(skyTex[texCycle]);    
  laserTexCur = loadImage( laserTex[texCycle] );
  //terrainTexCur = loadImage( terrainTex[texCycle] );
   //terrain.setTexture(terrainTexCur, TERRAIN_SLICES);
  println("Texture for laser:", laserTexCur, "Texture for sky:", skyTexCur, "texture for terrain:", terrainTexCur);

  if (texCycle < 5) {
    texCycle++;
  }
  else {
    texCycle = 0;
  }
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
void renderGlobe() {
  pushMatrix();
  // println(cam.eye());
  camVector = cam.pos;


  float cX = camVector.x;
  float cY = camVector.y;
  float cZ = camVector.z;
  translate(cX, cY, cZ);
  //translate(width * 0.33, height * 0.5, pushBack);
  noFill();
  pushMatrix();  
  tint(255, 200);
  //  stroke(255, 200);
  strokeWeight(2);
  smooth();
  //popMatrix();
  //lights();    
  //pushMatrix();
  textureMode(IMAGE);  
  texturedSphere(globeRadius, texGlobe);
  popMatrix();  
  popMatrix();
  noTint();
}
void initializeSphere(int res)
{
  sinLUT = new float[SINCOS_LENGTH];
  cosLUT = new float[SINCOS_LENGTH];

  for (int i = 0; i < SINCOS_LENGTH; i++) {
    sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * SINCOS_PRECISION);
    cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * SINCOS_PRECISION);
  }

  float delta = (float)SINCOS_LENGTH/res;
  float[] cx = new float[res];
  float[] cz = new float[res];

  // Calc unit circle in XZ plane
  for (int i = 0; i < res; i++) {
    cx[i] = -cosLUT[(int) (i*delta) % SINCOS_LENGTH];
    cz[i] = sinLUT[(int) (i*delta) % SINCOS_LENGTH];
  }

  // Computing vertexlist vertexlist starts at south pole
  int vertCount = res * (res-1) + 2;
  int currVert = 0;

  // Re-init arrays to store vertices
  sphereX = new float[vertCount];
  sphereY = new float[vertCount];
  sphereZ = new float[vertCount];
  float angle_step = (SINCOS_LENGTH*0.5f)/res;
  float angle = angle_step;

  // Step along Y axis
  for (int i = 1; i < res; i++) {
    float curradius = sinLUT[(int) angle % SINCOS_LENGTH];
    float currY = -cosLUT[(int) angle % SINCOS_LENGTH];
    for (int j = 0; j < res; j++) {
      sphereX[currVert] = cx[j] * curradius;
      sphereY[currVert] = currY;
      sphereZ[currVert++] = cz[j] * curradius;
    }
    angle += angle_step;
  }
  sDetail = res;
}

// Generic routine to draw textured sphere
void texturedSphere(float r, PImage t) {
  int v1, v11, v2;
  r = (r + 240 ) * 0.33;
  beginShape(TRIANGLE_STRIP);
  noStroke();
  texture(t);
  float iu=(float)(t.width-1)/(sDetail);
  float iv=(float)(t.height-1)/(sDetail);
  float u=0, v=iv;
  for (int i = 0; i < sDetail; i++) {
    vertex(0, -r, 0, u, 0);
    vertex(sphereX[i]*r, sphereY[i]*r, sphereZ[i]*r, u, v);
    u+=iu;
  }
  vertex(0, -r, 0, u, 0);
  vertex(sphereX[0]*r, sphereY[0]*r, sphereZ[0]*r, u, v);
  endShape();   

  // Middle rings
  int voff = 0;
  for (int i = 2; i < sDetail; i++) {
    v1=v11=voff;
    voff += sDetail;
    v2=voff;
    u=0;
    beginShape(TRIANGLE_STRIP);
    noStroke();
    texture(t);
    for (int j = 0; j < sDetail; j++) {
      vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1++]*r, u, v);
      vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2++]*r, u, v+iv);
      u+=iu;
    }
    // Close each ring
    v1=v11;
    v2=voff;
    vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1]*r, u, v);
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v+iv);
    endShape();
    v+=iv;
  }
  u=0;

  // Add the northern cap
  beginShape(TRIANGLE_STRIP);
  noStroke();
  texture(t);
  for (int i = 0; i < sDetail; i++) {
    v2 = voff + i;
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v);
    vertex(0, r, 0, u, v+iv);    
    u+=iu;
  }
  vertex(sphereX[voff]*r, sphereY[voff]*r, sphereZ[voff]*r, u, v);
  endShape();
}

