public class Walking{
    SinOsc sin1 => Chorus chorus => ADSR env1 => Gain master => Gain master2 => Gain level => dac;
    SinOsc sin2 => chorus => env1 => master;
    SinOsc sin3 => chorus => env1 => master;
    SinOsc sin4 => chorus => env1 => master;
    TriOsc bass => chorus => env1 => master;
    
    env1.set(5::ms, 0::ms, 1,5::ms);
    20 => chorus.modFreq;
    0.2 => chorus.modDepth;
    0.5 => chorus.mix;
    0.5 => level.gain;
    440 => sin1.freq => sin2.freq => sin3.freq => sin4.freq;
    0 => master.gain;
    fun void dead(){
        0 => master2.gain;   
    }
    fun void alive(){
        0.12 => master2.gain;   
    }
    fun void walk(int xSpeed, int ySpeed, float aDiff){
        
        if (aDiff > 55){
            //<<<"*******SPRINTING**************">>>;
            //<<<"xSpeed :", xSpeed>>>;
            //<<<"ySpeed :", ySpeed>>>;
            //<<<"ADiff :", aDiff>>>;
            env1.keyOn();
            1 => sin3.gain => sin4.gain;
            0.7 => bass.gain;
            xSpeed*23 => sin1.freq;
            ySpeed*11 => sin2.freq;
            aDiff*7 => sin3.freq;
            aDiff*27 => sin4.freq;
            (xSpeed + ySpeed) * 3 => bass.freq;
            aDiff/26000 => master.gain; 
            .05::second => now;
            env1.keyOff();
        }
        
        else if (aDiff > 45){
            //<<<"*****Running*****">>>;
            //<<<"xSpeed :", xSpeed>>>;
            //<<<"ySpeed :", ySpeed>>>;
            //<<<"ADiff :", aDiff>>>;
            env1.keyOn();
            1 => sin3.gain;
            0 => sin4.gain;
            0.7 => bass.gain;
            xSpeed*23 => sin1.freq;
            ySpeed*11 => sin2.freq;
            aDiff*17 => sin3.freq;
            (xSpeed + ySpeed) * 3 => bass.freq;
            aDiff/24000 => master.gain; 
            
            .05::second => now;
            env1.keyOff();
            
        }
        else if (aDiff > 35){
            //<<<"Trotting">>>;
            //<<<"xSpeed :", xSpeed>>>;
            //<<<"ySpeed :", ySpeed>>>;
            //<<<"ADiff :", aDiff>>>;
            0 => sin3.gain => sin4.gain;
            env1.keyOn();
            xSpeed*21 => sin1.freq;
            ySpeed*12 => sin2.freq;
            (xSpeed + ySpeed) * 3 => bass.freq;
            aDiff/22000 => master.gain; 
            .05::second => now;
            env1.keyOff();
            
        }
        else if (aDiff > 10){
            //<<<"Walking">>>;
            //<<<"xSpeed :", xSpeed>>>;
            //<<<"ySpeed :", ySpeed>>>;
            //<<<"ADiff :", aDiff>>>;
            0 => sin3.gain => sin4.gain;
            0.7 => bass.gain;
            env1.keyOn();
            xSpeed*20 => sin1.freq;
            ySpeed*10 => sin2.freq;
            (xSpeed + ySpeed) * 3 => bass.freq;
            aDiff/20000 => master.gain; 
            .05::second => now;
            env1.keyOff();
            
        }
        
        else{
            0 => sin3.gain => sin4.gain;
            0.9 => bass.gain;
            env1.keyOff();
            0.2::second => now;
            //0 => master.gain;  
            // <<<"Osc's Turned Off">>>; 
        }
    }
}