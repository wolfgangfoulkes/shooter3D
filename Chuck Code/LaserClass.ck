public class Laser{
    SndBuf laser => Gain master => dac;
    SndBuf explosion1 => Gain master1 => dac;
    SndBuf explosion2 => Gain master2 => dac;
    0 => master.gain => master1.gain => master2.gain;
    
    10 => int shots;
    string laser_samples[6];
    string explosion_samples[5];
    
    me.dir() + "/audio/laser1.wav" => laser_samples[0]; 
    me.dir() + "/audio/laser2.wav" => laser_samples[1];
    me.dir() + "/audio/laser3.wav" => laser_samples[2];
    me.dir() + "/audio/laser4.wav" => laser_samples[3];
    me.dir() + "/audio/laser5.wav" => laser_samples[4];
    me.dir() + "/audio/laser6.wav" => laser_samples[5]; 
    
    me.dir() + "/audio/explosion1.wav" => explosion_samples[0];
    me.dir() + "/audio/explosion2.wav" => explosion_samples[1];
    me.dir() + "/audio/explosion3.wav" => explosion_samples[2];
    me.dir() + "/audio/explosion4.wav" => explosion_samples[3];
    me.dir() + "/audio/explosion5.wav" => explosion_samples[4];
    
    fun void shoot(){
        if (shots > 0){
        Math.random2f(0.55,0.65) => master.gain;
        laser_samples[Math.random2(0,5)] => laser.read;
        0 => laser.pos;
        Math.random2f(0.85,1.15) => laser.rate;
     shots--;   
    }
    else{
     <<<"You are out of Ammo">>>;   
    }
    }
    fun void explosion(){
        Math.random2f(0.65,0.75) => master1.gain;
       // Math.random2f(0.65,0.75) => master2.gain;
        explosion_samples[Math.random2(0,4)] => explosion1.read;
        //explosion_samples[Math.random(0,4)] => explosion2.read;
        0 => explosion1.pos => explosion2.pos;
        Math.random2f(0.9,1.1) => explosion1.rate;
        //Math.random2f(0.9,1.1) => explosion2.rate;
    }
    fun void reload(){
        10 => shots;
    }
    
}