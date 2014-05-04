public class Laser{
    SndBuf laser => Gain master => Chorus chorus1 => dac;
    SndBuf explosion1 => Gain master1 => Chorus chorus2 => dac;
    SndBuf explosion2 => Gain master2 => Chorus chorus3 => dac;
    0 => master.gain => master1.gain => master2.gain;
    20 => chorus1.modFreq => chorus2.modFreq => chorus3.modFreq;
    0.2 => chorus1.modDepth => chorus2.modDepth => chorus3.modDepth;
    0.5 => chorus1.mix => chorus2.mix => chorus3.mix;
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
            Math.random2f(0.55,0.65) => master.gain;
            laser_samples[Math.random2(0,laser_samples.cap()-1)] => laser.read;
            0 => laser.pos;
            Math.random2f(0.85,1.15) => laser.rate;
            shots--;   
        }
        else{
            <<<"You are out of Ammo">>>;   
            Math.random2f(0.55,0.65) => master.gain;
            click_samples[Math.random2(0,click_samples.cap()-1)] => laser.read;     
        }
    }
    
    fun void reload(){
        10 => shots;
        <<<"reloaded">>>;
    }
    
}