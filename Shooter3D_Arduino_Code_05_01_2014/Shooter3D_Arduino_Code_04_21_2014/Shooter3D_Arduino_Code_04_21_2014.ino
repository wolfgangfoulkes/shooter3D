#include <Wiichuck.h>
// c goes to analog pin 5
// d goes to analog pin 4
// + goes to 5v
// - goes to GND
WiiChuck player;


//the values from nunchuck
int joyX;
int joyY;
int accX, accY, accZ;
int pitch;
bool zButton, cButton;
//for smoothing 
int smooJoyX, smooJoyY, smooAccX, smooAccY, smooAccZ, smooPitch;
float smoothingAmt = 0.2;


void setup(){
  player.begin();
  player.calibrateJoy();
  Serial.begin(9600);
}

void loop(){
  player.update();
  joyX = 200 + player.readJoyX();
  joyY = 200 + player.readJoyY();//read pitch instead of Y in order to better control sprite
  
  accX = 500 + player.readRoll();;//add five hundred to avoid negative values
  accY = 500 + player.readPitch();//read pitch on both 
  accZ = 500 + player.readPitch();//reads pitch instead of Z
  zButton = player.zPressed();
  cButton = player.cPressed();

  smooJoyX = smooth(joyX, smoothingAmt, smooJoyX);
  smooJoyY = smooth(joyY, smoothingAmt, smooJoyY);
  smooAccX = smooth(accX, smoothingAmt, smooAccX);
  smooAccY = smooth(accY, smoothingAmt, smooAccY);
  smooAccZ = smooth(accZ, smoothingAmt, smooAccZ);
  //for testing
  /*
  Serial.print ("Raw Values :");
  Serial.print (joyX, DEC);
  Serial.print (",");
  Serial.print (joyY, DEC);
  Serial.print (",");
  Serial.print (accX, DEC);
  Serial.print (",");
  Serial.print (accY, DEC);
  Serial.print (",");
  Serial.print (accZ, DEC);
  Serial.print (",");
  Serial.print (zButton, DEC);
  Serial.print (",");
  Serial.print (cButton, DEC);
  Serial.print("\n");
  //allow program time to catch up
  delay(10);
  */
  //Serial.print("Smoothed Values");
  Serial.print (smooJoyX, DEC);
  Serial.print (",");
  Serial.print (smooJoyY, DEC);
  Serial.print (",");
  Serial.print (smooAccX, DEC);
  Serial.print (",");
  Serial.print (smooAccY, DEC);
  Serial.print (",");
  Serial.print (smooAccZ, DEC);
  Serial.print (",");
  Serial.print (zButton, DEC);
  Serial.print (",");
  Serial.print (cButton, DEC);
  //Serial.print("]");
  Serial.print("\n");
  delay(15);
}

int smooth(int data, float filterVal, float smoothedVal){


  if (filterVal > 1){      // check to make sure param's are within range
    filterVal = .99;
  }
  else if (filterVal <= 0){
    filterVal = 0;
  }

  smoothedVal = (data * (1 - filterVal)) + (smoothedVal  *  filterVal);

  return (int)smoothedVal;
}
