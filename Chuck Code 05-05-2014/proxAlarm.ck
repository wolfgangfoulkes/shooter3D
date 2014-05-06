public class proxAlarms{
    
    SinOsc sin1 => JCRev reverb => Gain master => dac;
    //just in case it is four player
    SinOsc sin2 => reverb;
    SinOsc sin3 => reverb;
    
    5000 => float freqBase;
    
    freqBase => sin1.freq => sin2.freq => sin3.freq;
    0 => sin1.gain => sin2.gain => sin3.gain;
    0.2 => reverb.mix;
    0.3 => master.gain;
    
 //TO CHANGE ALARM FREQ... NOT 100% ON IT
    fun void baseAdjust(){
        if(freqBase > 9500){
            4000 => freqBase;   
        }
        else{
            freqBase + 1 => freqBase;   
        }
    }
       //expects 0-1 as input
    fun void alarm(float playDist){
        baseAdjust();
        freqBase => sin1.freq;
        if(playDist < 1){
            1 - (Math.pow(playDist, 2)) => sin1.gain;//math might change but this makes it exponentional        }
        }
        else {
            0 => sin1.gain;   
        }
        
    }
    //overleaded alarm for 2 to four players
    fun void alarm(float play1, float play2){
        baseAdjust();
        freqBase => sin1.freq;
        freqBase * 0.87 => sin2.freq;
        if(play1 < 1){
            1 - (Math.pow(play1, 2)) => sin1.gain;
        }
        else{
            0 => sin1.gain;   
        }
        if(play2 < 1){
            1 - (Math.pow(play2, 2)) => sin2.gain;
        }
        else{
            0 => sin2.gain;   
        }
    }
    fun void alarm(float play1, float play2, float play3){
        baseAdjust();
        freqBase => sin1.freq;
        freqBase * 0.87 => sin2.freq;
        freqBase * 1.11 => sin3.freq;
        if(play1 < 1){
            1 - (Math.pow(play1, 2)) => sin1.gain;
        }
        else{
            0 => sin1.gain;   
        }
        if(play2 < 1){
            1 - (Math.pow(play2, 2)) => sin2.gain;
        }
        else{
            0 => sin2.gain;   
        }
        if(play3 < 1){
            1 - (Math.pow(play3, 2)) => sin2.gain;
        }
        else{
            0 => sin3.gain;   
        }
    }
}