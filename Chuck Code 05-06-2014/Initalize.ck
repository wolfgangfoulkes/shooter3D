//Master File
me.dir() + "/windTilt.ck" => string windTiltPath;
me.dir() + "/ambiance.ck" => string ambiancePath;
me.dir() + "/proxAlarm.ck" => string proxPath;
me.dir() + "/announcer.ck" => string announcerPath;
me.dir() + "/LaserClass.ck" => string laserPath;
me.dir() + "/walking.ck" => string walkingPath;
me.dir() + "/Axe.ck" => string axePath;
me.dir() + "/ScreamClass.ck" => string screamPath;
me.dir() + "/Explosion.ck" => string explosionPath;
me.dir() + "/oscRouter.ck" => string serialOscPath;

Machine.add(windTiltPath) => int windTilt;
Machine.add(ambiancePath) => int ambiance;
Machine.add(proxPath) => int proxAlarm;
Machine.add(explosionPath) => int explosion;
Machine.add(announcerPath) => int announcer;
Machine.add(screamPath) => int scream;
Machine.add(axePath) => int axe;
Machine.add(walkingPath) => int walk;
Machine.add(laserPath) => int laser;
Machine.add(serialOscPath) => int serialOsc;


1::week => now;

Machine.remove(windTilt);
Machine.remove(ambiance);
Machine.remove(proxAlarm);
Machine.remove(explosion);
Machine.remove(announcer);
Machine.remove(walk);
Machine.remove(serialOsc);
Machine.remove(laser);
Machine.remove(axe);
Machine.remove(scream);
//Machine.remove(scream);