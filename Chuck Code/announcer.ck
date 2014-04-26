public class Announcer {
    
    SndBuf announcer => Gain master => dac;
    
    0.5 => master.gain;
    
    string newPlayer[5];
    
    me.dir() + "/audio/newPlayer1.wav" => newPlayer[0];
    me.dir() + "/audio/newPlayer2.wav" => newPlayer[1];
    me.dir() + "/audio/newPlayer3.wav" => newPlayer[2];
    me.dir() + "/audio/newPlayer4.wav" => newPlayer[3];
    me.dir() + "/audio/newPlayer5.wav" => newPlayer[4];
    me.dir() + "/audio/newPlayer6.wav" => newPlayer[5];
    
    fun int read (int player)
    {
        newPlayer[player] => announcer.read;
        0 => announcer.pos;
        1.0 => announcer.rate;
    }
   
}