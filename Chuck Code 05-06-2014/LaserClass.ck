public class Laser{
    SndBuf laser => Gain master1 => ADSR env => Chorus chorus1 => JCRev reverb => Gain master => dac;
    SndBuf click => Gain master2 => Chorus chorus4 => env => reverb => master;
    SndBuf explosion1 => Gain master3 => Chorus chorus2 => env => reverb => master;
    TriOsc explosion2 => Chorus chorus3 => env => reverb => master;
    0.3 => explosion2.gain;
    1245 => explosion2.freq;
    //envR.set(0::ms,0::ms,1.0,10::ms);//for OOA clicks
    //0.2::second => dur reloadLength;
    0.005 => reverb.mix;
    0.5 => reverb.gain;
    env.set(10::ms, 30::ms, 0.82, 100::ms);
    0.65::second => dur laserLength;
    
    0.14 => master.gain;
    
    0 => master1.gain => master2.gain => master3.gain;
    20 => chorus1.modFreq => chorus2.modFreq => chorus3.modFreq => chorus4.modFreq;
    0.2 => chorus1.modDepth => chorus2.modDepth => chorus4.modDepth;
    0.5 => chorus1.mix => chorus2.mix => chorus3.mix => chorus4.mix;
    0.7  => chorus3.modDepth; 
    10 => int shots;
    
    string laser_samples[2];
    string click_samples[3];
    
    me.dir() + "/audio/laser1.wav" => laser_samples[0]; 
    me.dir() + "/audio/laser2.wav" => laser_samples[1];
    //me.dir() + "/audio/laser3.wav" => laser_samples[2];
    //me.dir() + "/audio/laser4.wav" => laser_samples[3];
    //me.dir() + "/audio/laser5.wav" => laser_samples[4];
    //me.dir() + "/audio/laser6.wav" => laser_samples[5]; 
    
    me.dir() + "/audio/noAmmo1.wav" => click_samples[0];
    me.dir() + "/audio/noAmmo2.wav" => click_samples[1];
    me.dir() + "/audio/noAmmo3.wav" => click_samples[2];
    //me.dir() + "/audio/explosion4.wav" => click_samples[3];
    //me.dir() + "/audio/explosion5.wav" => click_samples[4];
    
    fun void shoot(){
        if (shots > 0){
            env.keyOn();
            Math.random2(2100,2150) => explosion2.freq;
            Math.random2f(0.55,0.65) => master1.gain;
            Math.random2f(0.57,0.65) => master2.gain;
            Math.random2f(0.57,0.65) => master3.gain;
            Math.random2f(0.25,0.3) => explosion2.gain;
            laser_samples[Math.random2(0,laser_samples.cap()-1)] => laser.read;
            laser_samples[Math.random2(0,laser_samples.cap()-1)] => click.read;
            laser_samples[Math.random2(0,laser_samples.cap()-1)] => explosion1.read;
            explosion1.samples() => explosion1.pos;
            0 => click.pos;
            0 => laser.pos;
            Math.random2f(0.095,.305) => click.rate; 
            Math.random2f(1.9,3.15) => laser.rate;
            Math.random2f(-.25,-.145) => explosion1.rate;
            shots--;   
            laserLength => now;
            env.keyOff();
        }
        else{
            <<<"You are out of Ammo">>>;   
            Math.random2f(0.55,0.65) => master3.gain;
            click_samples[Math.random2(0,click_samples.cap()-1)] => click.read; 
            Math.random2f(0.95,1.05) => click.rate;    
        }
    }
    
    fun void reload(){
        10 => shots;
        <<<"reloaded">>>;
    }
    
}