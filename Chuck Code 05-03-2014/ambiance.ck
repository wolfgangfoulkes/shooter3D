public class soundTrack {
    /*
    SndBuf st => JCRev reverb => Gain master => dac;
    0.2 => reverb.mix;
    0.4 => master.gain;
    0 => int place;
    dur length;
    0 => int gate;
    
    string backgroundTunes[4];
    
    me.dir() + "/audio/soundTrack1.wav" => backgroundTunes[0];
    me.dir() + "/audio/soundTrack2.aiff" => backgroundTunes[1];
    me.dir() + "/audio/soundTrack3.wav" => backgroundTunes[2];
    me.dir() + "/audio/soundTrack4.wav" => backgroundTunes[3];
    
    backgroundTunes[Math.random2(0, backGroundTunes.cap()-1)] => st.read;
    
    fun void shuffle(){
        if (place < backgroundTunes.cap()){
            backgroundTunes[place] => st.read;   
            gate++;
            place++;
        }
        else{
            0 => place; 
            gate++;  
        }
    }
    
    fun void loop(){
        0 => gate;
        st.length() => length;
        while(gate < 1){
            0 => st.pos;
            //0.2 => st.rate;
            length => now;
        }  
    } 
    */
}
