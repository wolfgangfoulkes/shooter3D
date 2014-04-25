//Master File

me.dir() + "/LaserClass.ck" => string laserPath;
me.dir() + "/walking.ck" => string walkingPath;
me.dir() + "/Axe.ck" => string axePath;
me.dir() + "/arduinoToChuck.ck" => string serialOscPath;
me.dir() + "/ScreamClass.ck" => string screamPath;


Machine.add(screamPath) => int scream;
Machine.add(axePath) => int axe;
Machine.add(walkingPath) => int walk;
Machine.add(laserPath) => int laser;
Machine.add(serialOscPath) => int serialOsc;


1::week => now;
Machine.remove(walk);
Machine.remove(serialOsc);
Machine.remove(laser);
Machine.remove(axe);
Machine.remove(scream);
//Machine.remove(scream);