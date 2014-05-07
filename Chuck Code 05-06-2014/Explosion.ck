public class Explosion
{
    
    SndBuf impactBuf => Gain master => Chorus chorus => JCRev reverb => ADSR env => Gain level => dac;
    SndBuf low => master;
    
    
    env.set(2::ms, 30::ms, 0.9, 1::second);
    0.085 => reverb.mix;
    20 => chorus.modFreq;
    0.2 => chorus.modDepth;
    0.15 => chorus.mix;
    0 => master.gain;
    
    string low_samples[1];
    
    me.dir() + "/audio/lowEnd.wav" => low_samples[0];
    low_samples[0] => low.read;
    string impact_samples[5];
    
    me.dir() + "/audio/explosion1.wav" => impact_samples[0];
    me.dir() + "/audio/explosion2.wav" => impact_samples[1];
    me.dir() + "/audio/explosion3.wav" => impact_samples[2];
    me.dir() + "/audio/explosion4.wav" => impact_samples[3];
    me.dir() + "/audio/explosion5.wav" => impact_samples[4];
    //me.dir() + "/audio/impact6.wav" => impact_samples[5];
    
    fun void impact(){
        env.keyOn();
        Math.random2f(0.69,0.75) => master.gain;
        impact_samples[Math.random2(0,impact_samples.cap()-1)] => impactBuf.read;
        0 => impactBuf.pos => low.pos;
        Math.random2f(0.85,1.15) => impactBuf.rate;
        1 => low.rate; 
        32::ms  => now;  
        env.keyOff();
        1.7::second => now;
    }
}