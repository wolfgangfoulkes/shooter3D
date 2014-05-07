public class proxAlarms{
    
    TriOsc sin1 => Chorus chorus => JCRev reverb =>  Gain master => Gain level => dac;
    //just in case it is four player
    TriOsc sin2 => reverb;
    TriOsc sin3 => reverb;
    
    0.3 => level.gain;
    
    200 => chorus.modFreq;
    0.4 => chorus.modDepth;
    0.24 => chorus.mix;
    
    2000 => float freqBase;
    
    float playerDist1;
    float playerDist2;
    float playerDist3;
    
    freqBase => sin1.freq => sin2.freq => sin3.freq;
    0 => sin1.gain => sin2.gain => sin3.gain;
    0.4 => reverb.mix;
    0.1 => master.gain;
    
    //TO CHANGE ALARM FREQ... NOT 100% ON IT
    fun void baseAdjust(){
        if(freqBase > 4500){
            4000 => freqBase;   
        }
        else{
            freqBase*1.02 => freqBase;   
        }
    }
    //expects 0-1 as input
    
    fun void alarm(float playDist){
        baseAdjust();
        freqBase => sin1.freq;
        if((playDist < 1) || (playDist == 1)){
            1 - (Math.pow(playDist, 3)) => playerDist1;//math might change but this makes it exponentional
            if (playerDist1 < 1){
                playerDist1 => sin1.gain;
            }
            else{
                0 => sin1.gain;   
            }
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
        if((play1 < 1)|| (play1 == 1)){//not sure is this is less than or equal to
            1 - (Math.pow(play1, 3)) => playerDist1;
            if (playerDist1 < 1){
                playerDist1 => sin1.gain;
            }
            else{
                0 => sin1.gain;   
            }
        }
        else{
            0 => sin1.gain;   
        }
        if((play2 < 1)|| (play2 == 1)){
            1 - (Math.pow(play2, 3)) => playerDist2;
            if (playerDist2 < 1){
                playerDist2 => sin2.gain;
            }
            else{
                0 => sin2.gain;   
            }
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
        if((play1 < 1)|| (play1 == 1)){
            //<<<"Entered the If for play1">>>;
            1 - (Math.pow(play1, 3)) => playerDist1;
            //<<<playerDist1>>>;
            if (playerDist1 < 1){
                playerDist1 => sin1.gain;
            }
            else{
                0 => sin1.gain;   
            }
        }
        else{
            0 => sin1.gain;   
        }
        if((play2 < 1)|| (play2 == 1)){
            1 - (Math.pow(play2, 3)) => playerDist2;
            if (playerDist2 < 1){
                playerDist2 => sin2.gain;
            }
            else{
                0 => sin2.gain;   
            } 
        }
        else{
            0 => sin2.gain;   
        }
        if((play3 < 1)|| (play3 == 1)){
            1 - (Math.pow(play3, 3)) => sin2.gain;
            if (playerDist2 < 1){
                playerDist2 => sin2.gain;
            }
            else{
                0 => sin2.gain;   
            }
        }
        else{
            0 => sin3.gain;   
        }
    }
}