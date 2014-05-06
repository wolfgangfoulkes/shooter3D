public class Scream {
    
    adc => FFT fft =^ RMS rms => blackhole;
    
    adc => LiSa screamLisa => Chorus chorus => JCRev reverb => Gain master => dac; 
    
    200 => chorus.modFreq;
    0.4 => chorus.modDepth;
    0.34 => chorus.mix;
    
    
    0.22 => reverb.mix;
    1 => screamLisa.bi;
    100::ms => dur recFadeTime;
    //fft settings
    256 => fft.size;
    256 => int WinSize;
    second/samp => float samplerate;
    Windowing.hann(WinSize) => fft.window;
    //for the scream placyback
    0 => int screamTime;
    0.00250 => float threshold;//0.008 ish for installation
    6::minute => screamLisa.duration;//extremely long duration seems to not help much
    0 => int gate;
    1 => screamLisa.rate;
    0.6 => master.gain;
    1 => screamLisa.maxVoices;//limiting voices doesn't help (its like tracks)
    screamLisa.loop(1);//setting the recorder to loop mode doesn't help
    
    fun void killed(){
        //adc =< dac;
        //0.4 => master.gain;
        
        <<<"Long Scream">>>;
        screamLisa.playPos(1::ms);
        screamLisa.recPos(1::ms);
        screamLisa.play(1);
        screamLisa.rampUp(0.2::second);
        ((screamTime)*0.5)::second => now;
        screamLisa.rampDown(0.1::second);
        0.1::second => now;
        screamLisa.play(0);
        screamLisa.clear();
    }
    fun void dead(){
        0 => gate;
        0 => screamTime;
        
        screamLisa.track(0);
        // 0 => screamLisa.recordPos;
        <<<"Player Death Data Received">>>;
        while(gate < 1){
            rms.upchuck() @=> UAnaBlob blobRMS;//0.04 is loud
            //<<<blobRMS.fval(0)>>>;
            if(blobRMS.fval(0) > threshold){
                screamLisa.playPos(1::ms);
                screamLisa.recPos(1::ms);
                
                screamLisa.record(1); 
                //env.keyOn();
                //recFadeTime => now;
                while(blobRMS.fval(0) > threshold/3){
                    .5::second => now;   
                    rms.upchuck() @=> UAnaBlob blobRMS;//0.04 is loud
                    <<<blobRMS.fval(0)>>>;
                    screamTime++;
                }
                
                //env.keyOff();
                //recFadeTime => now;
                screamLisa.record(0);
                gate++;
                <<<"Player Respawning">>>;
            }
            else{
                //tells processing to prompt player to scream
                //<<<"Please Scream Loudly to Respawn">>>;  
            } 
            10::ms => now;
        } 
        // 0 => master.gain;  
    }
}

