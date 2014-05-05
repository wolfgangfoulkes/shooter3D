public class Scream {
    
    adc => FFT fft =^ RMS rms => blackhole;
    
    adc => LiSa screamLisa => JCRev reverb => Gain master => dac;
    
    0.4 => reverb.mix;
    
    
    //fft settings
    256 => fft.size;
    256 => int WinSize;
    second/samp => float samplerate;
    Windowing.hann(WinSize) => fft.window;
   //for the scream placyback
    0 => int screamTime;
    0.0065 => float threshold;//0.008 ish for installation
    15000::ms => screamLisa.duration;
    0 => int gate;
    1 => screamLisa.rate;
    0.4 => master.gain;
    30 => screamLisa.maxVoices;//perhaps this will solves our problem
    //this message is for when the player is killed
    
    
    fun void killed(){
        
//0.4 => master.gain;
        if( screamTime > 4){
            <<<"Long Scream">>>;
            screamLisa.playPos(0::ms);
            screamLisa.play(1);
            screamLisa.rampUp(0.2::second);
            ((screamTime - 2 )*0.1)::second => now;
            screamLisa.rampDown(0.1::second);
            0.1::second => now;
            screamLisa.play(0);
            screamLisa.clear();
            //0.8::second => now;//for reverb tail
        }
        /*
        else if(screamTime > 2){
            <<<"Shorter Scream">>>;
            screamLisa.playPos(0::ms);
            screamLisa.play(1);
            screamLisa.rampUp(0.05::second);
            (screamTime - 1 )* 0.1::second => now;
            screamLisa.rampDown(0.1::second);
            0.1::second => now;
            screamLisa.play(0);
            
            screamLisa.clear();
            //0 => master.gain;
        }
        */
        else{
            <<<"Too Short for Playback">>>;  
            screamLisa.clear(); 
        }
        
    }
    /*
    fun int screamL(){
        int screamTime;   
    }
    */
    fun void dead(){
        0 => gate;
        <<<"Player Death Data Sent">>>;
        while(gate < 1){
            rms.upchuck() @=> UAnaBlob blobRMS;//0.04 is loud
            <<<blobRMS.fval(0)>>>;
            if(blobRMS.fval(0) > threshold){
                screamLisa.record(1); 
                while(blobRMS.fval(0) > threshold/3){
                    .1::second => now;   
                    rms.upchuck() @=> UAnaBlob blobRMS;//0.04 is loud
                    <<<blobRMS.fval(0)>>>;
                    screamTime++;
                }
                screamLisa.record(0);
                gate++;
                <<<"Player Respawning">>>;
            }
            else{
                //tells processing to prompt player to scream
                <<<"Please Scream Loudly to Respawn">>>;  
            } 
            100::ms => now;
        } 
       // 0 => master.gain;  
    }
}

