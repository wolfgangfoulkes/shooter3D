public class Walking{
    SndBuf walkBuf => Gain master => dac;
    0.6 => master.gain;
    
    string walk_samples[1];
    
    me.dir() + "/audio/walking.wav" => walk_samples[0]; 
    
    fun void walk(){
        Math.random2f(0.35,0.45) => master.gain;
        walk_samples[0] => walkBuf.read;
        0 => walkBuf.pos;
        Math.random2f(0.95,1.05) => walkBuf.rate;
        
    }
    
    fun void run(){
        Math.random2f(0.35,0.45) => master.gain;
        walk_samples[0] => walkBuf.read;
        0 => walkBuf.pos;
        Math.random2f(1.95,2.05) => walkBuf.rate;
        
    }
}