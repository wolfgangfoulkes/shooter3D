public class Announcer {
    
    SndBuf announcer => Gain master => dac;
    
    0 => master.gain;
    
    string newPlayer[6];
    
    me.dir() + "/audio/newPlayer1.wav" => newPlayer[0];
    me.dir() + "/audio/newPlayer2.wav" => newPlayer[1];
    me.dir() + "/audio/newPlayer3.wav" => newPlayer[2];
    me.dir() + "/audio/newPlayer4.wav" => newPlayer[3];
    me.dir() + "/audio/newPlayer5.wav" => newPlayer[4];
    me.dir() + "/audio/newPlayer6.wav" => newPlayer[5];
    
    fun void newP()
    {
        newPlayer[Math.random2(0,newPlayer.cap() -1)] => announcer.read;
        0 => announcer.pos;
        1.0 => announcer.rate;
        Math.random2f(0.5,0.6) => master.gain;
        3::second => now;
    }
    
   
}