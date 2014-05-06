public class Explosion
{
    
    SndBuf impactBuf => Gain master => dac;
    SndBuf low => master;
    
    
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
        Math.random2f(0.49,0.61) => master.gain;
        impact_samples[Math.random2(0,impact_samples.cap()-1)] => impactBuf.read;
        0 => impactBuf.pos => low.pos;
        Math.random2f(0.85,1.15) => impactBuf.rate;
        1 => low.rate;   
    }
}