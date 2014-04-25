//A simple Particle class that defines one particle object

class Particle {
  PVector loc;     // stores the particles XY position on the screen 
  PVector vel;     // stores the particles speed of travel
  float rad;       // radius (size) of the particle
  PVector decay;   // stores the rate at which particles slow down over time

  int age;         // the age (in frames) of the particle
  int lifeSpan;    // paricles life span (how long it can live)
  boolean isDead;  // flag which the ParticleSystem checks to see if it should update or remove the particle
  float agePer;    // float used to modulate the radius over time in relationship to lifespan

  PImage bloodTex;
  String[] blood = new String[]{
  "blood1.jpg", "blood2.png", "blood3.png"  
  };
  

  Particle(PVector l) {
    loc = l;
    vel = new PVector(random(-10, 10), random(-10, 10), random(-10, 10));  // random speed of travel (play with these)
    decay = new PVector(0.9, 0.9, 0.9);                  // how quickly the particles slow down (play with this)
    age = 0;                                          // initial age is 0
    lifeSpan = (int)random(20, 50);                  // randomize lifeSpan so each particles dies at slightly different times
    isDead = false;                                   // particle starts alive
    rad = 10.0;
  }

  // update is where all of the particles properties are updated
  // before drawing
  void update() {
    if (age < 1){
     bloodTex = loadImage(blood[(int)random(0,blood.length)]);
    }
    age++;                                            // every frame we update the particles age
    agePer = 1.0 - (age / (float)lifeSpan);            // update and modulate radius over time
    rad = 10.0 * agePer;                              // actually update the radius
    loc.add(vel);
    //vel.mult(decay);

    if (age > lifeSpan) {
      isDead = true;
    }
  }

  //will be called to actually draw the particle to the screen
  void draw() {
    
    noStroke();
    //lights();
    pushMatrix();
    fill(255, 0, 0);
    translate(loc.x, loc.y, loc.z);
    beginShape();
    //texture(bloodTex);
    vertex(random(0, 50), random(0, 50), random(0, 50), random(0, 50) );
    vertex(random(0, 50), random(0, 50), random(0, 50), random(0, 50) );
    vertex(random(0, 50), random(0, 50), random(0, 50), random(0, 50) );
    vertex(random(0, 50), random(0, 50), random(0, 50), random(0, 50) );
    vertex(random(0, 50), random(0, 50), random(0, 50), random(0, 50) );
    
    endShape();
    //sphere((int)random(1,3));

    popMatrix();
    //fill(NONE);
    //


    // ellipseMode(CENTER);
    //fill(255, 255, 255, 100);
    // ellipse(loc.x, loc.y,  rad, rad);
    //for 2d rendering
  }
}

