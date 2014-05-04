//A class which manages a colelction of Particles

class ParticleSystem {
  ArrayList<Particle> particleCollection;
  int size;

  ParticleSystem() {
    particleCollection = new ArrayList<Particle>();
    size = 0;
  }

  void update() {
    Iterator<Particle> p = particleCollection.iterator();
    while (p.hasNext ()) {
      Particle part = p.next();
      if (part.isDead == true) {
        p.remove();
      }
      else {
        part.update();
      }
    }
    size = particleCollection.size();
  }

  void draw() {
    //using an interator (instead of a for loop) to loop through our
    // particle array list, and call each particles draw() function
    Iterator<Particle> p = particleCollection.iterator();
    while (p.hasNext ()) {
      p.next().draw();
      //print("paticle updated");
    }
  }

  //called to add new particles
  void addParticles(int amt, PVector location) {
    //loop and create our particles with a bit of randomness...
    for (int i=0; i<amt; i++) {
      PVector rand = new PVector(random(-10, 10), random(-10, 10),random(-10, 10));
      particleCollection.add( new Particle(PVector.add(location, rand)));
      //println("Particle Created");
    }
    size = particleCollection.size();
  }
}
