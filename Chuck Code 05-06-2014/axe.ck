public class Axe{
    
    SndBuf axe1 => ADSR env =>  Chorus chorus => Gain master1 => dac;
    SndBuf axe2 => env => JCRev reverb => Gain master2 => dac;
    SndBuf axe3 => env => chorus => Gain master3;
    
    0.035 => reverb.mix;
    
    20 => chorus.modFreq;
    0.2 => chorus.modDepth;
    0.4 => chorus.mix;
    //for envelope
    env.set(10::ms, 30::ms, 0.8,100::ms);
    0.5::second => dur length;
    
    float axe1Rate, axe2Rate, axe3Rate;
    
    string impact_samples[8];
    
    me.dir() + "/audio/woosh1.wav" => impact_samples[0];
    me.dir() + "/audio/woosh2.wav" => impact_samples[1];
    me.dir() + "/audio/woosh3.wav" => impact_samples[2];
    me.dir() + "/audio/woosh4.wav" => impact_samples[3];
    me.dir() + "/audio/woosh5.wav" => impact_samples[4];
    me.dir() + "/audio/woosh6.wav" => impact_samples[5];
    me.dir() + "/audio/woosh7.wav" => impact_samples[6];
    me.dir() + "/audio/woosh8.wav" => impact_samples[7];
    
    fun void swing(){
        <<<"Swing">>>;
        env.keyOn();//only needs to be triggered in swing, they both play at same time
        Math.random2f(0.42,0.55) => master1.gain;
        Math.random2f(0.42,0.55) => master2.gain;
        Math.random2f(0.42,0.55) => master3.gain;
        impact_samples[Math.random2(0,impact_samples.cap()-1)] => axe1.read;
        impact_samples[Math.random2(0,impact_samples.cap()-1)] => axe2.read;
        impact_samples[Math.random2(0,impact_samples.cap()-1)] => axe3.read;
        
        Math.random2f(-1.25,1.35) => axe1Rate;
        Math.random2f(-1.25,1.35) => axe2Rate;
        Math.random2f(-1.25,1.35) => axe3Rate;
       // <<<"rate1", axe1Rate,"rate2", axe2Rate,"Rate3", axe3Rate>>>;
        if (axe1Rate < 0){
            axe1.samples() => axe1.pos;
            axe1Rate => axe1.rate;   
        }
        else if ( axe1Rate > 0){
            0 => axe1.pos;
            axe1Rate => axe1.rate;
        }
        else{
            0 => axe1.pos;
            1 => axe1.rate;   
        }
        
        if (axe1Rate < 0){
            axe2.samples() => axe2.pos;
            axe2Rate => axe2.rate;   
        }
        else if ( axe2Rate > 0){
            0 => axe2.pos;
            axe2Rate => axe2.rate;
        }
        else{
            0 => axe2.pos;
            1 => axe2.rate;   
        }
        
        if (axe3Rate < 0){
            axe3.samples() => axe3.pos;
            axe3Rate => axe3.rate;   
        }
        else if ( axe3Rate > 0){
            0 => axe3.pos;
            axe3Rate => axe3.rate;
        }
        else{
            0 => axe3.pos;
            1 => axe1.rate;   
        }
        
        length => now;
        env.keyOff();
        100::ms => now;
    }
}