public class Announcer {
    
    SndBuf announcer => Gain master => ADSR env1 =>  dac;
    SndBuf announcer1 => Gain master1 => ADSR env2 => dac;
    0 => master.gain => master1.gain;
    
    env1.set(10::ms,1::ms, .99,0.1::second);
    env2.set(10::ms,1::ms, .99,0.1::second);
    
    string newPlayer[6];
    
    me.dir() + "/audio/newPlayer1.wav" => newPlayer[0];
    me.dir() + "/audio/newPlayer2.wav" => newPlayer[1];
    me.dir() + "/audio/newPlayer3.wav" => newPlayer[2];
    me.dir() + "/audio/newPlayer4.wav" => newPlayer[3];
    me.dir() + "/audio/newPlayer5.wav" => newPlayer[4];
    me.dir() + "/audio/newPlayer6.wav" => newPlayer[5];
    
    string playerKilled[5];
    
    me.dir() + "/audio/playerKilled1.wav" => playerKilled[0];
    me.dir() + "/audio/playerKilled2.wav" => playerKilled[1];
    me.dir() + "/audio/playerKilled3.wav" => playerKilled[2];
    me.dir() + "/audio/playerKilled4.wav" => playerKilled[3];
    me.dir() + "/audio/playerKilled4.wav" => playerKilled[4];
    
    fun void announceNewPlayer()
    {
        env1.keyOn();
        newPlayer[Math.random2(0,newPlayer.cap() -1)] => announcer.read;
        0 => announcer.pos;
        1 => announcer.rate;
        0.72 => master.gain;
        (announcer.samples() - 4100)::samp => now;
        env1.keyOff;
        4100::samp => now;
    }
    
    fun void announceOppKill(){
        env2.keyOn();
        playerKilled[Math.random2(0,playerKilled.cap() -1)] => announcer1.read;
        0 => announcer1.pos;
        1.0 => announcer1.rate;
        0.72 => master1.gain;
        (announcer1.samples() - 4100)::samp => now;
        env2.keyOff;
        4100::samp => now;
    }
  
    
}