"/tweez" => string myPrefix;

OscRecv oscIn;
14000 => oscIn.port;
oscIn.listen();

OscSend xmit;
xmit.setHost("localhost", 14001);

oscIn.event(myPrefix + "/kill, s") @=> OscEvent playerKilled;

spork ~ playerKillListen();
1::week => now;

fun void playerKillListen() {
    while(true){
        playerKilled => now;
        
        if (playerKilled.nextMsg() != 0) {
            playerKilled.getString() => string playerPre;
            <<<playerPre + " killed!">>>;
            if (playerPre == myPrefix)
            {
                1 => int deathStatus;
                1::second => now;
                sendRespawnPing();
            }
            
            /*
            if(firstTime > 0){scream.killed(); 2.5::second => now;}
            else{
                scream.dead();
                firstTime++;
            }
            sendRespawnPing();
            */
        }
    }   
}

fun void sendRespawnPing(){
    xmit.startMsg("/chuck/init", "i");
    xmit.addInt(1);
    <<<"Respawn Ping sent to Processing">>>;
    
}