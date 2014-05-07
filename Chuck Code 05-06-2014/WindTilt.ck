public class WindTilt{
    
    
    LiSa looper => JCRev reverb => Chorus chorus => Gain master => Gain level => blackhole;
    SndBuf buf => reverb => chorus => master => dac;
    SinOsc tracker => looper;
    Step off => looper;
    
    20 => chorus.modFreq;
    0.2 => chorus.modDepth;
    0.5 => chorus.mix;
    .9 => level.gain;
    0.1 => float trackerGain;
    0 => int gate;
    0.22 => reverb.mix;
    0.097 => master.gain;
    float average;
    string windSounds[3];
    
    me.dir() + "/audio/wind1.wav" => windSounds[0];
    me.dir() + "/audio/wind2.wav" => windSounds[1];
    me.dir() + "/audio/wind3.wav" => windSounds[2];
    
    //windSounds[2] => buf.read;
    
    fun void tiltData(int accX, int accY){
        //<<<"data Received", accX, accY>>>;
        (Std.abs(accX) + accY) => average;  
        //<<<"Average :", average>>>;
        Std.ftoi(average * 5) => buf.pos;
        accX * 0.5 => buf.rate;
        accY / 200 => buf.gain; 
       // 10::ms => now;
    }
    
    
    fun void loadSample(int arrayPos){
        <<<"New SAmple LOaded">>>;
        if (arrayPos < windSounds.cap()){
            windSounds[arrayPos] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
            /*
            while(true){
                1 => looper.sync;
                trackerGain => tracker.freq;
                0.5 => tracker.gain;
                //0.5 => off.next; 
                1 => looper.play;
                trackerGain => looper.gain;
                buf.samples()::samp => now;
            }
            */
        }
        else{
            windSounds[Math.random2(0,windSounds.cap()-1)] => buf.read;
            buf.samples()::samp => looper.duration;  
            for ( 0 => int i; i < buf.samples(); i++){
                looper.valueAt(buf.valueAt(i), i::samp);//puts values into LiSa   
            }
            /*
            while(true){
                1 => looper.sync;
                0.025 => tracker.freq;
                trackerGain => tracker.gain;
                0.0 => off.next; 
                1 => looper.play;
                1.0 => looper.gain;
                buf.samples()::samp => now;     
            }
            */
        }   
    }   
}