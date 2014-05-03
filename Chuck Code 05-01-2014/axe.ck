public class Axe{
    
    SndBuf axe => Gain master => dac;
    SndBuf impactBuf => Gain master1 => dac;
    
    0.6 => master.gain;
    
    string axe_samples[6];
    string impact_samples[6];
    
    me.dir() + "/audio/axe1.aiff" => axe_samples[0]; 
    me.dir() + "/audio/axe2.aiff" => axe_samples[1];
    me.dir() + "/audio/axe3.aiff" => axe_samples[2];
    me.dir() + "/audio/axe4.aiff" => axe_samples[3];
    me.dir() + "/audio/axe5.aiff" => axe_samples[4];
    me.dir() + "/audio/axe6.aiff" => axe_samples[5];  
    
    me.dir() + "/audio/impact1.wav" => impact_samples[0];
    me.dir() + "/audio/impact2.wav" => impact_samples[1];
    me.dir() + "/audio/impact3.wav" => impact_samples[2];
    me.dir() + "/audio/impact4.wav" => impact_samples[3];
    me.dir() + "/audio/impact5.wav" => impact_samples[4];
    me.dir() + "/audio/impact6.wav" => impact_samples[5];
   
    
    fun void swing(){
        Math.random2f(0.55,0.65) => master.gain;
        axe_samples[Math.random2(0,5)] => axe.read;
        0 => axe.pos;
        Math.random2f(0.75,1.25) => axe.rate;
        2::second => now;
    }
    
    fun void impact(){
        Math.random2f(0.35,0.45) => master1.gain;
        impact_samples[Math.random2(0,6)] => impactBuf.read;
        0 => impactBuf.pos;
        Math.random2f(0.85,1.15) => impactBuf.rate;   
        2::second => now;
    }
    
}