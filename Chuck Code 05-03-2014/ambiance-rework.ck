public class soundTrack{
    
    SndBuf buf;
    LiSa looper => JCRev reverb => Gain master => dac;
    SinOsc tracker => looper;
    Step off => looper;
    
    0 => int gate;
    0.12 => reverb.mix;
    0.07 => master.gain;
    
    string backgroundTunes[4];
    
    me.dir() + "/audio/soundTrack1.wav" => backgroundTunes[0];
    me.dir() + "/audio/soundTrack2.aiff" => backgroundTunes[1];
    me.dir() + "/audio/soundTrack3.wav" => backgroundTunes[2];
    me.dir() + "/audio/soundTrack4.wav" => backgroundTunes[3];
    
    fun void loadSample(int arrayPos){
        
        if (arrayPos < backgroundTunes.cap()){
            backgroundTunes[arrayPos] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
            while(true){
                1 => looper.sync;
                0.025 => tracker.freq;
                1.0 => tracker.gain;
                0.0 => off.next; 
                1 => looper.play;
                1.0 => looper.gain;
                buf.samples()::samp => now;
            }
        }
        else{
            backgroundTunes[Math.random2(0,backgroundTunes.cap()-1)] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
            while(true){
               1 => looper.sync;
                0.025 => tracker.freq;
                1.0 => tracker.gain;
                0.0 => off.next; 
                1 => looper.play;
                1.0 => looper.gain;
                buf.samples()::samp => now;            }
        }   
    }   
}