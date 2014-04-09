import oscP5.*;
import netP5.*;
import papaya.*;
//all the values for sky
PImage bg;
PImage texmap;

PFont font;
int lifeStatus = 0;
int sDetail = 100;  // Sphere detail setting
float rotationX = 0;
float rotationY = 0;
float velocityX = 0;
float velocityY = 0;
float globeRadius = 12000;
float pushBack = 0;

float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5;
int SINCOS_LENGTH = int(360.0 / SINCOS_PRECISION);


//variables for other things
PImage grass;
PVector look = new PVector(0, 0, 0);
PVector loc = new PVector(0, 0, 0);
PImage sky;
//for sphere you are inside..
//need to figure out how to map textures to the inside of 3d objects
float x_acc, y_acc, z_acc, z_button, c_button;
PVector joystick = new PVector(0, 0); 
laserObject laser;
OscP5 oscP5;
NetAddress myRemoteLocation;
//Object3D2 triangle;
Camera cam;
Map map;

/*
boolean sketchFullScreen(){
  return true;
}
*/

void setup() 
{

  smooth();
  size(1080, 720, P3D);
  //size(displayWidth,displayHeight,P3D);
  //set default values for camera
  texmap = loadImage("sky.jpg");    
  initializeSphere(sDetail);
  grass = loadImage("Grass.jpg");

  oscP5 = new OscP5(this, 1234);//listening
  myRemoteLocation = new NetAddress("127.0.0.1", 10000);//sending
  //a way of parsing the OSC data more effectivly
  oscP5.plug(this, "accelData", "/nunchuck/accel");
  oscP5.plug(this, "cButtonData", "/nunchuck/Cbutton");
  oscP5.plug(this, "zButtonData", "/nunchuck/Zbutton");
  oscP5.plug(this, "joystickData", "/nunchuck/joystick");
  oscP5.plug(this, "respawnData", "/player/respawn");
  //calls font
  font = createFont("Georgia", 50);//font type, font size, anti-ailising on

  fill(255, 0, 0);
  noStroke();

  cam = new Camera();
  cam.look(x_acc, y_acc, 450);
  cam.display();

  map = new Map();
  spawnObjects();
  //map.objects.add(new Object3D(0, 0, -450, 0, 0, 0)); //0, 360
  //map.objects.add(new Object3D(450, 10, 0, 0, 0, 0));  //90
  //map.objects.add(new Object3D(0, 15, 450, 0, 0, 0));  //180
  //map.objects.add(new Object3D(-450, 20, 0, 0, 0, 0));  //270
  font = createFont("Georgia", 60, true);//font type, font size, anti-ailising on
  frameRate(24);
}


void draw()
{
  /*
  if (lifeStatus < 1) {
   
   background(0);
   
   //textMode(SCREEN);
   textFont(font);
   textAlign(CENTER, CENTER);
   fill(200,0,0);
   text("You Are Dead", width/2, (height/2) - 40, -60);
   text("Please Scream to Respawn", (width/2), (height/2) + 40, 30);
   //add some trigger via OSC from chuck to set life status to 1
   }
   else { */
  //renders camera
  cam.look(x_acc, y_acc, 450);
  cam.display();
  //renders sky
  renderGlobe(); 
  lights(); 
  //renders floor
  grassFloor();

  fill(200, 200, 255);
  map.display();

  if (map.checkBounds(PVector.add(cam.pos, joystick)) == -1)
  {
    cam.move(joystick);
  }
  else
  {
    println("boundary!", cam.pos);
  }

  //println(cam.pos, map.objects.get(0).p);
  //println(degrees(PVector.angleBetween(PVector.sub(cam.look, cam.pos), PVector.sub(map.objects.get(0).p, cam.pos))));

  //println(x_axis);
  //println(y_axis);
  //println(x_acc);
  //println(y_acc);
  //println(z_acc);
  // println(z_button);
  // println(c_button);
  //line(displayWidth/2+25,displayHeight/2,0,displayWidth/2-25,displayHeight/2,-25);
  //line(displayWidth/2,displayHeight/2+25,0,displayWidth/2,displayHeight/2-25,0);
}

public void spawnObjects(){
  int amount = (int)random(35,80);
  for(int i = 0; i < amount; i++){
    map.objects.add(new Object3D((int)random(-3000,3000), (int)random(0,35), (int)random(-3000, 3000), 0, 0, 0)); //0, 360
  //  map.objects2.add(new Object3D2(random(-3000,3000), random(0,35), random(-3000, 3000), 0.0, 0.0, 0.0)); //0, 360
  }
}

public void joystickData(int x, int z) {

  if (x > 132 || x < 118)
  {
    joystick.x = map(constrain(x, -100, 100), 50, 200, -1, 1); //need to be -1 - 1 //you had a small typo here that was probably causing all kinda havok
    //println("Received Joystick Data");
    //convert to 0-1 to control speed.
    print("Joystick X :");
    println(joystick.x);
  }
  else { //can't include both in the same if/then clause. second conditional only applies if first is false
    joystick.x = 0;
  }
  
  if (z > 132 || z < 118) {
    joystick.z = map(constrain(z, -100, 100), 50, 200, -1, 1);
    println("Received Joystick Data");
    print("Joystick Z :");
    println(joystick.z);
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
  sendShot();
}
public void cButtonData(int c) {
  c_button = c;
  println("Received C Button Bang");
  println(c_button);
  //if (c > 0){
  sendShot();

  //}
}
public void respawnData(int status) {
  if (status == 0) {
    //please scream to respawn
  }
  if (status == 1) {
    //Kill The Other Players
    //respawn player
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
    x_acc = map(constrain(x, -80, 80), -80, 80, -1, 1); //needs to be -1 - 1
    y_acc = map(constrain(x, -80, 170), -80, 170, -1, 1); 
    z_acc = map(constrain(x, -50, 130), -50, 130, -1, 1);
  }
  ///println("Received accel Data");
  //println(x_acc, y_acc, z_acc);
}

public void buttons(int z, int c)
{
  if (map.destroy(cam.pos, cam.look) == -1)
  {
    println("missed!", PVector.sub(cam.look, cam.pos));
  }
  else
  {
    println("shot 'em dead!");
  }
}

void sendShot() {
  look = cam.pInfo();
  loc = cam.lInfo();
  //laser.fire(loc.x, loc.y, loc.z, look.x, look.y, look.z);
  println("Send Shot");
  println(look);
  println(loc);
}

void grassFloor() {
  noStroke();
  pushMatrix();
  translate(0, 30, 0);//moves plane to below players feet so you can't look through
  beginShape();
  texture(grass);//map the shape with PImage grass
  textureWrap(REPEAT);//repeat the texture instead of stretching
  vertex(-27000, 50, -27000, 0, 0);
  vertex(27000, 50, -27000, grass.width*50, 0);
  vertex(27000, 50, 27000, grass.width*50, grass.height*50);
  vertex(-27000, 50, 27000, 0, grass.height*50);
  endShape();
  popMatrix();
}

void renderGlobe() {
  pushMatrix();
  translate(width * 0.33, height * 0.5, pushBack);
  pushMatrix();  
  noFill();
  stroke(255, 200);
  strokeWeight(2);
  smooth();
  popMatrix();
  lights();    
  pushMatrix();
  rotateX( radians(-rotationX) );  
  rotateY( radians(270 - rotationY) );
  fill(200);
  noStroke();
  textureMode(IMAGE);  
  texturedSphere(globeRadius, texmap);
  popMatrix();  
  popMatrix();
  rotationX += velocityX;
  rotationY += velocityY;
  velocityX *= 0.95;
  velocityY *= 0.95;
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

