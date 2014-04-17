// this is an option
import oscP5.*;
import netP5.*;
import papaya.*;
import processing.video.*;
import java.util.*; 
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;
import processing.opengl.*;

Particle particle;
ParticleSystem explosion;
Terrain terrain;
//playerO
Tube axe;
Cone[] droids;
Tube[] tube;
Ellipsoid[] obelisk;
OscP5 oscP5;
NetAddress myRemoteLocation;
//camera courdinates extraxted from vector
float cX;
  float cY;
  float cZ;

PVector location;
int nbrPO;
//crappy system for removing lasers
int lifeSpan = 11;
//for axe mov't (broken at moment)
PVector axeMvt = new PVector(10, -2, 0);
PVector camVector = new PVector(0, 0, 0);
//for sky rendering
PImage texGlobe;//can be sent to other MAC's to allow for background sync
float globeRadius = 12000;//size of world
int sDetail = 50;  // Sphere detail setting...number of triangles
float pushBack = 0;//for rendering
//for the box objects
PVector[] droidDirs;
int nbrDroids;
//for buildings
int nbrOb;
int nbrTube;
//for handeling death
PFont font;
//if the player is dead or not
int lifeStatus = 0;// 0 = dead, 1 = alive
//for camera object and terrain
TerrainCam cam;
int camHoversAt = 10;
float terrainSize = 1200;
float horizon = 185;
float camSpeed = 10;
float sideStep = 0;
int gridSlices = 16;
//Math Stuff
float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5;
int SINCOS_LENGTH = int(360.0 / SINCOS_PRECISION);
//for the particle system
//need to transfer over to shapes3D
PVector look = new PVector(0, 0, 0);//almost seems to be where the player is
PVector loc = new PVector(0, 0, 0);
//timing related
long itter;
long time;
int count;
//for the ground
String[] respawnText = new String[]{
  "respawn1.png","respawn2.png","respawn3.png","respawn4.png"
};
String[] axeTex = new String[] {
 "axe1.jpg","axe2.png","axe3.png","axe4.jpg","axe5.jpg" 
};
String[] laserTex = new String[] {
  "laser1.jpg", "laser2.jpg", "laser3.JPG", "laser4.jpg",
};
String[] terrainTex = new String[] {//textures for terrain
  "floor1.jpg", "floor2.gif", "floor3.jpg", "floor4.jpg", "floor5.jpg", "floor6.jpg", "floor7.jpg","floor8.jpg","floor9.jpg"
};
//variables from nunchuck
float x_acc, y_acc, z_acc, z_button, c_button;
PVector joystick = new PVector(0, 0); 
// List of image files for texture for objects
String[] buildTex = new String[] {
  "build1.jpg", "build2.jpg", "build3.jpg", "build4.jpg"
};
String[] skyTex = new String[] {//could load fog as background
  "sky1.jpg", "sky2.jpg", "sky3.jpg", "sky4.jpg", "sky5.jpg", "sky6.jpg", "sky7.jpg", "sky8.jpg", "sky9.jpg"
};
String[] droidTex = new String[] {
  "droid1.jpg", "droid2.jpg", "droid3.jpg", "droid4.jpg","droid5.jpg","droid6.jpg","droid7.JPG","droid8.jpg",
};
/*
boolean sketchFullScreen() {
  return true;
}
*/
void setup() {

   size(1404, 1080, P3D);
   mouseX = width/2;
   mouseY = height/2;
  cursor(CROSS);//sets curser as cross
  noLights();
  noStroke();
 
  //size(displayWidth, displayHeight, P3D);
  //initalizing the sky/globe
  texGlobe = loadImage(skyTex[(int)random(0, skyTex.length)]);    
  initializeSphere(sDetail);
  //for terrain initialization
  terrain = new Terrain(this, gridSlices, terrainSize, horizon);
  terrain.usePerlinNoiseMap(-70, 70, 2.125f, 2.125f);
  terrain.setTexture(terrainTex[(int)random(0, terrainTex.length)], 16);
  terrain.tag = "Ground";
  terrain.tagNo = -1;
  terrain.drawMode(S3D.TEXTURE);
  //OSC stuff
  oscP5 = new OscP5(this, 1234);//listening
  myRemoteLocation = new NetAddress("127.0.0.1", 1235);//sending
  //a way of parsing the OSC data more effectivly
  oscP5.plug(this, "accelData", "/nunchuck/accel");
  oscP5.plug(this, "cButtonData", "/nunchuck/Cbutton");
  oscP5.plug(this, "zButtonData", "/nunchuck/Zbutton");
  oscP5.plug(this, "joystickData", "/nunchuck/joystick");
  oscP5.plug(this, "respawnData", "/player/respawn");
  //for death/respawn
  font = createFont("Georgia", 90, true);//font type, font size, anti-ailising on
  //for explosions
  explosion = new ParticleSystem();

//for player objects
  nbrPO = 200;
  /* for (int i = 1; i < nbrPO; i++){
   playerO[i] = new 
   playerO[i] 
   }*/



  // droids (fire or trees or fog or something else
  nbrDroids = 406;
  droids = new Cone[nbrDroids];
  droidDirs = new PVector[nbrDroids];
  for (int i = 0; i < nbrDroids; i++) {
    droids[i] = new Cone(this, 30);
    droids[i].setSize(random(2, 15), random(2, 15), random(50, 70));
    droids[i].moveTo(getRandomPosOnTerrain(terrain, terrainSize, -10));
    droids[i].tagNo = 100 + i;
    droids[i].drawMode(S3D.TEXTURE);
    droids[i].setTexture(droidTex[(int)random(0, droidTex.length)]);
    terrain.addShape(droids[i]);
  }
  //for Obelisk objects
  nbrOb = 3;
  obelisk = new Ellipsoid[nbrOb];
  for (int i = 0; i < nbrOb; i++) { 
    obelisk[i] = new Ellipsoid(this, 4, 20);
    obelisk[i].setRadius((int)random(30, 60), (int)random(200, 400), (int)random(30, 60));
    obelisk[i].moveTo(getRandomPosOnTerrain(terrain, terrainSize, 28));
    //obelisk.fill(color(0));
    obelisk[i].tag = "Globe" + ""+i;
    obelisk[i].tagNo = 1+i;
    obelisk[i].setTexture(buildTex[(int)random(0, buildTex.length)]);
    obelisk[i].drawMode(S3D.TEXTURE);
    terrain.addShape(obelisk[i]);
    print("obelisk created");
  }
  //for Tube Objects
  nbrTube = 30;
  tube = new Tube[nbrTube];

  for (int i = 0; i < nbrTube; i++) {
    tube[i] = new Tube(this, 4, 10);
    tube[i].setSize((int)random(20, 40), (int)random(20, 50), (int)random(20, 50), (int)random(20, 50), (int)random(80, 150));
    tube[i].moveTo(getRandomPosOnTerrain(terrain, terrainSize, 15.5));
    tube[i].tagNo = 1000 + i;
    tube[i].setTexture(buildTex[(int)random(0, buildTex.length)]);
    tube[i].drawMode(S3D.TEXTURE);
    //tube[i].fill(color(255, 0, 0), Tube.S_CAP);
    //tube[i].fill(color(0, 255, 0), Tube.E_CAP);
    tube[i].drawMode(S3D.SOLID, Tube.BOTH_CAP);
    terrain.addShape(tube[i]);
  }
  //for the camera
  camSpeed = 10;
  cam = new TerrainCam(this);
  cam.adjustToTerrain(terrain, Terrain.WRAP, camHoversAt);
  cam.camera();
  cam.speed(camSpeed);
  //cam.forward.set(cam.lookDir());

  terrain.cam = cam;// Tell the terrain what camera to use

  time = millis();
}

void draw() {

  if ((itter % 10000) == 99999) {
    texGlobe = loadImage(skyTex[(int)random(0, skyTex.length)]);
  }
  if ((itter % 17000) == 16999) {
    terrain.setTexture(terrainTex[(int)random(0, terrainTex.length)], 16); //last number should be base 4
  }
  background(0);
  // Get elapsed time
  long t = millis() - time;
  time = millis();
  // before any rendering or what not we check if the player is alive or dead
  /*
    if (lifeStatus < 1) {
   PImage backgroundImg = loadImage(respawnText[(int)random(0,respawnText.length)]);
   background(backgroundImg);
   //camera needs to be modified to see text properly
   //camera (width/2 + 900, height/2, -2, //no y movement
   //-100, -50, -150,
   //1.0, 1.0, 0.0
   //);
   //textMode(SCREEN);
   //textFont(font);
   //textAlign(CENTER, CENTER);
   //fill(200, 0, 0);
   //text("You Are Dead", width/2, (height/2) - 40, -60);
   //text("Please Scream to Respawn", (width/2), (height/2) + 40, 30);
   
   //add some trigger via OSC from chuck to set life status to 1
   }
   else { */
  //renders sky
  renderGlobe(); 

  // Update shapes on terrain
  update(t/1000.0f);

  cam.rotateViewBy(x_acc);
  cam.turnBy(x_acc);
  // Update camera speed and direction
  if (mousePressed) {
    float achange = (mouseX - pmouseX) * PI / width;
    //location.x = 200;
    //location.y = 80;
    //location.z = 200;
    // Keep view and move directions the same
    cam.rotateViewBy(achange);
    cam.turnBy(achange);
    
  }
  // Update camera speed and direction
  if (keyPressed) {
    if (key == 'W' || key =='w' || key == 'P' || key == 'p') {
      camSpeed += (t/100.0f);
      cam.speed(camSpeed);
    }
    else if (key == 'S' || key =='s' || key == 'L' || key == 'l') {
      camSpeed -= (t/100.0f);
      cam.speed(camSpeed);
    }
    //else if (keyPressed == 'e'){
    //cam.viewTo(); 
    //}
    else if (key == 'e'){
     lifeSpan = 0;
    laserAttack(); 
    }
    else if (key == ' ') {
      sideStep = 0;
      camSpeed = 0;
      cam.speed(camSpeed);
    }
    else if (key == 'q') {
      lifeSpan = 0; 
      axeAttack();
    }
  }
  // Calculate amount of movement based on velocity and time
  cam.move(t/1000.0f);
  cam.forward.set(sideStep, 0, camSpeed);
  cam.adjustToTerrain(terrain, Terrain.WRAP, camHoversAt);
  cam.camera();
  
  
  updateParticles();
  terrain.draw();
  itter++;
  /*
  PVector camEye = cam.eye();
  float camEyeX = camEye.x;
  float camEyeY = camEye.y;
  float camEyeZ = camEye.z;
    PVector camLookDir = cam.lookDir();
    float camLookX = camLookDir.x;
  float camLookZ = camLookDir.y;
  float camLookY = camLookDir.z;
  spotLight(255.0,0.0,0.0,camEyeX,camEyeY,camEyeZ,camLookX,camLookY,camLookZ,PI/2.0,10000.0);
  */
}

/**
 * Update droid rotation
 */
public void update(float time) {
  
  
  for (int i = 0; i < nbrDroids; i++) {
    droids[i].rotateBy(0, time*radians(10.871f), 0);
  }
}

/**
 * Get a random position on the terrain avoiding the edges
 * @param t the terrain
 * @param tsize the size of the terrain
 * @param height height above terrain
 * @return
 */
public PVector getRandomPosOnTerrain(Terrain t, float tsize, float height) {
  PVector p = new PVector(random(-tsize/2.1f, tsize/2.1f), 0, random(-tsize/2.1f, tsize/2.1f));
  p.y = t.getHeight(p.x, p.z) - height;
  return p;
}

/**
 * Get random direction for seekers.
 * @param speed
 */
public PVector getRandomVelocity(float speed) {
  PVector v = new PVector(random(-10000, 10000), 0, random(-10000, 10000));
  v.normalize();
  v.mult(speed);
  return v;
}
//for working with the explosion particle systems

void updateParticles() {
  if (mousePressed == true) {
    
  explosion.addParticles(20, cam.eye());
  }
  explosion.update();
  explosion.draw(); //call draw on our particleSystem to draw all particles
}
//all the plugging functions
public void joystickData(int x, int z) {
  if (x > 132 || x < 118)
  {
    joystick.x = 1*map(constrain(x, 25, 230), 25, 230, -2, 2); //need to be -1 - 1 //you had a small typo here that was probably causing all kinda havok
    //convert to -1,1 to control speed.
    sideStep =  joystick.x;
    //pushMatrix();
    //translate(sideStep,0,0);
    //popMatrix();
    print("Joystick X :");
    println(joystick.x);
  }
  else { //can't include both in the same if/then clause. second conditional only applies if first is false
    joystick.x = 0;
  }

  if (z > 132 || z < 118) {
    joystick.z = map(constrain(z, 25, 230), 25, 230, -1, 1);
    camSpeed += joystick.z;
    cam.speed(camSpeed);

    //print("Joystick Z :");
    //println(joystick.z);
  }
  else {
    joystick.z = 0;
  }
  println(joystick.x, joystick.z);
}


public void zButtonData(int z) {
  z_button = z;
  println("Received Z Button Bang");
  println(z_button);
}
public void cButtonData(int c) {
  c_button = c;
  println("Received C Button Bang");
  println(c_button);
}
public void respawnData(int status) {
  if (status == 0) {
    lifeStatus = 0;
    //webCam.newPlayer();
    println("Death Data Sent");
    OscMessage  playerDied = new OscMessage("/player/death");
    playerDied.add(1);
    oscP5.send(playerDied, myRemoteLocation);
    //please scream to respawn
  }
  if (status == 1) {
    lifeStatus = 1;
    println("Respawn Trigger Sent");
    //Kill The Other Players
    //respawn player
  }
}
public void axeAttack() {
  axe = new Tube(this, (int)random(1, 10),(int)random(1,10), cam.lookDir(), cam.lookDir());
  axe.setSize(1.7, 0, 1.2, 0.5, 2.0);
  axe.tagNo = 666;
  String texHolder = laserTex[(int)random(0, laserTex.length)];
  axe.setTexture(texHolder);
  axe.drawMode(S3D.TEXTURE);
  axe.setTexture(texHolder);
  axe.drawMode(S3D.TEXTURE, Tube.BOTH_CAP);
  terrain.addShape(axe);
  //terrain.removeShape(axe);
  if (lifeSpan < 2) {
    lifeSpan++; 
    println(lifeSpan);
    //axe.setWorldPos(cam.eye(),cam.eye());
    camVector = cam.eye();
    axeMvt = cam.lookDir();
   //camVector.mult(cam.lookDir());
   camVector.add(axeMvt);
    axe.moveTo(camVector);
    println(cam.lookDir());
    //axe.moveTo(cam.lookDir());
  }
  else {
    terrain.removeShape(axe);
  }
}
//the following code is for a laser really

public void laserAttack(){
 
 if(lifeSpan < 2){
 lifeSpan++; 
 println(lifeSpan);
 axe = new Tube(this, 10 ,30,cam.lookDir(),cam.lookDir());
 axe.setSize(.12,.12,.12,.12,1000.0);
 //axe.setWorldPos(cam.eye(),cam.eye());
 axe.moveTo(cam.eye());
 axe.tagNo = 666;
 axe.setTexture(laserTex[(int)random(0,laserTex.length)]);
 axe.drawMode(S3D.TEXTURE);
 axe.setTexture(laserTex[(int)random(0,laserTex.length)]);
 //axe.drawMode(S3D.TEXTURE, Tube.BOTH_CAP);
 terrain.addShape(axe);
 //terrain.removeShape(axe);
 }
 else if (lifeSpan == 2){
   for (int i = 0; i < lifeSpan; i++){
 terrain.removeShape(axe);
 }
 }
}

public void accelData(int x, int y, int z) {
  if (x > 50 && x < 70) {  //pretty silly, this is what was here //if (x < 50 && x > 50) {
    x_acc = 0;
  }
  if (y > 50 && y < 70) { //if (y < 50 && y > 70) { //
    y_acc = 0;
  }
  else
  {
    //we made an error here, where we were multiplying the constrained value against itself. 
    //this (and the typo above) was the route of all our rotation problems, 
    //because the angle increased exponentially and never became negative.
    //you may still want to scale these values to tweak rotation (remember to scale -1 and 1 by the same amount)
    x_acc = 0.2*map(constrain(x, -80, 80), -80, 80, -1, 1); //needs to be -1 - 1
    y_acc = 0.2*map(constrain(x, -80, 170), -80, 170, -1, 1); 
    z_acc = 0.2*map(constrain(x, -50, 130), -50, 130, -1, 1);
  }
  ///println("Received accel Data");
  //println(x_acc, y_acc, z_acc);
}

/**
 
 public void mouseClicked(){
 cam.camera();
 Shape3D selected = Shape3D.pickShape(this, mouseX, mouseY);
 println(selected);
 if(selected != null){
 if(selected.tagNo > textures.length)
 selected .fill(color(random(128,255), random(128,255), random(128,255)));
 else if(selected.tagNo >= 0){
 selected.tagNo = (selected.tagNo + 1) % textures.length;
 selected.setTexture(textures[selected.tagNo]);
 }
 }
 }
 
 */
/// Everything from here on is for the sky
///
///

void renderGlobe() {
  pushMatrix();
  // println(cam.eye());
  camVector = cam.eye();
  
  
  float cX = camVector.x;
  float cY = camVector.y;
  float cZ = camVector.z;
  translate(cX, cY, cZ);
  //translate(width * 0.33, height * 0.5, pushBack);
  noFill();
  pushMatrix();  
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

