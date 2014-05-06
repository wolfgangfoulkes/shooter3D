public class Announcer {
    
    SndBuf announcer => Gain master => dac;
    SndBuf announcer1 => master;
    0 => master.gain;
    
    string newPlayer[6];
    
    me.dir() + "/audio/newPlayer1.wav" => newPlayer[0];
    me.dir() + "/audio/newPlayer2.wav" => newPlayer[1];
    me.dir() + "/audio/newPlayer3.wav" => newPlayer[2];
    me.dir() + "/audio/newPlayer4.wav" => newPlayer[3];
    me.dir() + "/audio/newPlayer5.wav" => newPlayer[4];
    me.dir() + "/audio/newPlayer6.wav" => newPlayer[5];
    
    string playerKilled[6];
    
    me.dir() + "/audio/playerKilled1.wav" => playerKilled[0];
    me.dir() + "/audio/playerKilled2.wav" => playerKilled[1];
    me.dir() + "/audio/playerKilled3.wav" => playerKilled[2];
    me.dir() + "/audio/playerKilled4.wav" => playerKilled[3];
    me.dir() + "/audio/playerKilled5.wav" => playerKilled[4];
    me.dir() + "/audio/playerKilled6.wav" => playerKilled[5];
    
    fun void oppKill(){
        playerKilled[Math.random2(0,playerKilled.cap() -1)] => announcer1.read;
        0 => announcer1.pos;
        1.0 => announcer1.rate;
        0.65 => master1.gain;
    }
    
    fun void newPlayer()
    {
        newPlayer[Math.random2(0,newPlayer.cap() -1)] => announcer.read;
        0 => announcer.pos;
        1.0 => announcer.rate;
        0.65 => master.gain;
    }
  
    
}