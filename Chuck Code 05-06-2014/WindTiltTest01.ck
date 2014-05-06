public class WindTilt{
    
    SndBuf buf;
    LiSa looper => JCRev reverb => Chorus chorus => Gain master => dac;
    SinOsc tracker => looper;
    Step off => looper;
    
     20 => chorus.modFreq;
    0.2 => chorus.modDepth;
    0.5 => chorus.mix;
    
    1.0 => float trackerGain;
    0 => int gate;
    0.22 => reverb.mix;
    0.07 => master.gain;
    float average;
    string windSounds[3];
    
    me.dir() + "/audio/wind1.wav" => windSounds[0];
    me.dir() + "/audio/wind2.wav" => windSounds[1];
    me.dir() + "/audio/wind3.wav" => windSounds[2];
    
    fun void tiltData(int accX, int accY){
        <<<"data Received", accX, accY>>>;
     (Std.abs(accX) + accY)/300 => average;   
     average => trackerGain;
    }
    
    
    fun void loadSample(int arrayPos){
        
        if (arrayPos < windSounds.cap()){
            windSounds[arrayPos] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
            while(true){
                1 => looper.sync;
                trackerGain => tracker.freq;
                0.5 => tracker.gain;
                0.5 => off.next; 
                1 => looper.play;
                trackerGain => looper.gain;
                buf.samples()::samp => now;
            }
        }
        else{
            windSounds[Math.random2(0,windSounds.cap()-1)] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
            while(true){
                1 => looper.sync;
                0.025 => tracker.freq;
                trackerGain => tracker.gain;
                0.0 => off.next; 
                1 => looper.play;
                1.0 => looper.gain;
                buf.samples()::samp => now;     
                       }
            }   
        }   
    }