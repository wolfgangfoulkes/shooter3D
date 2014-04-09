class laserObject {
  int age = 0;
  PVector location;
 PVector destination;
 
 laserObject(){
  
 }
 
 void fire(float xloc,float yloc,float zloc, float xaim, float yaim, float zaim){
  location.x = xloc;
  location.y = yloc;
  location.z = zloc;
  destination.x = xaim;
  destination.y = yaim;
  destination.z = zaim;
   //line(location.x, location.y, location.z, location.x, location.y, location.z +15);
 }
 
 void move(){
  
  if (age < 20){
    location.z = location.z + 15;
    age++;
  //line(location.x, location.y, location.z, location.x, location.y, location.z +15);
  }
 }
 void draw() {
   if (age < 20){
    location.z = location.z + 15;
    age++;
  //line(location.x, location.y, location.z, location.x, location.y, location.z +15);
  }
   line(location.x, location.y, location.z, location.x, location.y, location.z +15);
 }
  
}
