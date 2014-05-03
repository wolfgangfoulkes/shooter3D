public class Scream {
    
    adc => FFT fft =^ RMS rms => blackhole;
    
    adc => LiSa screamLisa => Gain master => dac;
    //fft settings
    256 => fft.size;
    256 => int WinSize;
    second/samp => float samplerate;
    //sets the windowing of the FFT
    Windowing.hann(WinSize) => fft.window;
    //OSC stuff
    0 => int screamTime;
    0.0095 => float threshold;
    150000::ms => screamLisa.duration;
    0 => int gate;
    1 => screamLisa.rate;
    0.5 => master.gain;
    //this message is for when the player is killed
    
    
    fun void killed(){
        <<<"playing back player scream">>>;
        //screamLisa.playPos(0);
        screamLisa.play(1);
        screamLisa.rampUp(0.1::second);
        ((screamTime - 3)*0.1)::second => now;
        screamLisa.rampDown(0.2::second);
        0.2::second => now;
        screamLisa.play(0);
    }
    
    fun void dead(){
        0 => gate;
        <<<"Player Death Data Sent">>>;
        while(gate < 1){
            //gets info from my FFT analysis and sends them to blobs
            rms.upchuck() @=> UAnaBlob blobRMS;//0.04 is loud
            //for testing
            <<<blobRMS.fval(0)>>>;
            //100::ms => now;
            
            if(blobRMS.fval(0) > threshold){
                
                screamLisa.record(1); 
                while(blobRMS.fval(0) > threshold/2){
                 .1::second => now;   
                 rms.upchuck() @=> UAnaBlob blobRMS;//0.04 is loud
            //for testing
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
                0.5::second => now;
            } 
        }   
    }
}

