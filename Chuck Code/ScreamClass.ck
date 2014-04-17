public class Scream {
    
    adc => FFT fft =^ RMS rms => blackhole;
    
    adc => LiSa screamLisa => Gain master => dac;
    //fft settings
    256 => fft.size;
    256 => int WinSize;
    second/samp => float samplerate;
    //sets the windowing of the FFT
    Windowing.hann(WinSize) => fft.window;
    
    0.01 => float threshold;
    1500::ms => screamLisa.duration;
    0 => int gate;
    1 => screamLisa.rate;
    0.5 => master.gain;
    //osc info to send messages for player respawn
    OscSend oscOut;
    //OscRecv oscIn;
    1235 => oscIn.port;
    oscOut("localhost", 1234);
    //this message is for when the player is killed
    
    //oscIn.event("/player/death, i") @=> OscEvent playerDeath;
    
    
    fun void killed(){
        screamLisa.play(1);
        1.5::second => now;
        screamLisa.play(0);
    }
    
    fun void dead(){
        0 => gate;
        oscOut.startMsg("player/respawn", "i");
        oscOut.addInt(0);
        <<<"Player Death Data Sent">>>;
        while(gate < 1){
            //gets info from my FFT analysis and sends them to blobs
            rms.upchuck() @=> UAnaBlob blobRMS;//0.04 is loud
            //for testing
            <<<blobRMS.fval(0)>>>;
            100::ms => now;
            
            if(blobRMS.fval(0) > threshold){
                screamLisa.record(1);   
                1.5::second => now;
                screamLisa.record(0);
                //send OSC to processing to allow respawn
                oscOut.startMsg("player/respawn", "i");
                oscOut.addInt(1);
                gate++;
                <<<"Player Respawning">>>;
                
            }
            else{
                //tells processing to prompt player to scream
                
                <<<"Please Scream Loudly to Respawn">>>;
            } 
        }   
    }
}