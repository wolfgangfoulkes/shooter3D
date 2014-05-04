#include <Wiichuck.h>
// c goes to analog pin 5
// d goes to analog pin 4
// + goes to 5v
// - goes to GND
WiiChuck player;

int joyX;
int joyY;
int acc_x, acc_y, acc_z;
int pitch;
bool z_button, c_button;


void setup(){
  player.begin();
  player.calibrateJoy();
  Serial.begin(9600);
}

void loop(){
  player.update();
  joyX = 200 + player.readJoyX();
  joyY = 200 + player.readJoyY();//read pitch instead of Y in order to better control sprite
  
  acc_x = 500 + player.readRoll();;//add five hundred to avoid negative values
  acc_y = 500 + player.readPitch();//read pitch on both 
  acc_z = 500 + player.readPitch();//reads pitch instead of Z
  z_button = player.zPressed();
  c_button = player.cPressed();

  Serial.print (joyX, DEC);

  Serial.print (",");
  Serial.print (joyY, DEC);
  Serial.print (",");
  Serial.print (acc_x, DEC);
  Serial.print (",");
  Serial.print (acc_y, DEC);
  Serial.print (",");
  Serial.print (acc_z, DEC);
  Serial.print (",");
  Serial.print (z_button, DEC);
  Serial.print (",");
  Serial.print (c_button, DEC);
  //Serial.print("]");
  Serial.print("\n");
  delay(30);
}
