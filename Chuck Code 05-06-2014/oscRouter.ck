//////////////////////////////SETUP FOR COMMUNICATIONS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
// serial handling
SerialIO serial;
string line;//the data comming in
"/tweez" => string myPrefix;
second/samp => float samplerate;
//sets the windowing of the FFT
2 => int serialPort;
//osc info to send messages for player respawn
//set up OSC to send info
OscSend xmit;
xmit.setHost("localhost",14001);
//set up OSC to look for messages
OscRecv oscIn;
14000 => oscIn.port;
//for when the player hits an object with the axe
oscIn.listen();

oscIn.event(myPrefix + "/axe, i") @=> OscEvent axeImpact;//or shot
oscIn.event(myPrefix + "/shot, i") @=> OscEvent laserImpact;//or shot
oscIn.event(myPrefix + "/kill, s") @=> OscEvent playerKilled;
oscIn.event("/arena/newPlayer, i") @=> OscEvent newPlayer;
oscIn.event(myPrefix + "/explosion, i") @=> OscEvent explosion;
oscIn.event(myPrefix + "/oppProx, f") @=> OscEvent opponentProx2;
oscIn.event(myPrefix + "/oppProx, f,f") @=> OscEvent opponentProx3;
oscIn.event(myPrefix + "/oppProx, f,f,f") @=> OscEvent opponentProx4;

SerialIO.list() @=> string list[];
for( int i; i< list.cap(); i++ )
{
    chout <= i <= ": " <= list[i] <= IO.newline();
}
//opens serial ports
serial.open(serialPort, SerialIO.B9600, SerialIO.ASCII);
/////////////////////////////////////////
Axe axe;
Walking walking;
Laser laser;
Scream scream;
Explosion boom;
Announcer announcer;
proxAlarms proxAlarm;
soundTrack ambiance;
WindTilt windTilt;
//////////////////////////////////////////////////////////
int xDiff, yDiff;
float aDiff;
//string and int values for data from nunchuck
0 => int runState;
//initalize SndBuf classes
0 => int firstTime;
int x_axis;
int y_axis;
int x_acc;
int y_acc;
int z_acc;
int z_button;
int c_button;
string x_axisS, y_axisS ,x_accS ,y_accS, z_accS,z_buttonS,c_buttonS;
//lists serial ports

1::second => now;//to make sure program does not initalize in the middle of a message
spork ~ serialPoller();
spork ~ sendJoyData();
spork ~ sendAccData();
spork ~ playerKillListen();
spork ~ newPlayerPoll();
spork ~ explosionPoll();

//spork ~ windTilt.loadSample(50);

while (true) {
    0.5::second => now;
    if (runState < 1){//to avoid false triggers and uneeded noise
        1 => runState;
        //windTilt.loadSample(0);
    }
    /*
    <<<"x_axis :", x_axis>>>;
    <<<"y_axis :", y_axis>>>;
    <<<"x_acc :", x_acc>>>;
    <<<"y_acc :", y_acc>>>;
    <<<"z_acc :", z_acc>>>;
    <<<"-------------------------">>>;
    0.5::second => now; 
    */
}

//////////     **********OUTGOING COMMUNICATION FUNCTIONS*********     \\\\\\\\\\
fun void sendJoyData(){
    while(1){
        if (runState == 1){
            aDif();
            walking.walk(xDiff, yDiff, aDiff); 
            xmit.startMsg("/nunchuck/joystick", "i,i");
            xmit.addInt(x_axis * runState);
            xmit.addInt(y_axis * runState);
            10::ms => now;
        }
        else{
            xmit.startMsg("/nunchuck/joystick", "i,i");
            xmit.addInt(x_axis * runState);
            xmit.addInt(y_axis * runState);
            10::ms => now;// to not overload chuck
        }
    }
}

fun void sendAccData(){
    while(true){
        if(runState==1){
        xmit.startMsg("/nunchuck/accel", "i,i,i");
        xmit.addInt(x_acc);
        xmit.addInt(y_acc);
        xmit.addInt(z_acc);
        windTilt.tiltData(x_acc, y_acc);
        10::ms => now;
    }
    10::ms => now;
    }
}

fun void sendCButtonData(){//laser
    if (runState == 1){
        xmit.startMsg("/nunchuck/Cbutton", "i"); 
        xmit.addInt(c_button);  
        laser.shoot();  
        <<<"C Button Pressed">>>;    
    }
}

fun void sendZButtonData(){//the melee attack
    if(runState == 1){
        xmit.startMsg("/nunchuck/Zbutton", "i"); 
        xmit.addInt(z_button);
        axe.swing(); //dont spork it if we want it to wait until you attack again...
        <<<"Z Button Pressed">>>;
    }
}
fun void sendRespawnPing(){
    xmit.startMsg("/chuck/init", "i");
    xmit.addInt(1);
    <<<"Respawn Ping sent to Processing">>>;
    laser.reload();
    
    ambiance.loadSample(50);//the 50 will just cause the function to randomly choose a sample 
}

//////////     **********ALL POLLING FUNCTIONS*********     \\\\\\\\\\
fun void proximityPoll2P(){
    while(1){
        opponentProx2 => now;   
        if (opponentProx2.nextMsg() != 0){
            opponentProx2.getFloat() => float opp1;
            proxAlarm.alarm(opp1);
        }
    }   
}
//if we have 3 players
fun void proximityPoll3P(){
    while(1){
        opponentProx3 => now;   
        if (opponentProx3.nextMsg() != 0){
            opponentProx3.getFloat() => float opp1;
            opponentProx3.getFloat() => float opp2;
            proxAlarm.alarm(opp1, opp2);
        }
    }   
}
//if we have 4 players
fun void proximityPoll4P(){
    while(1){
        opponentProx4 => now;   
        if (opponentProx4.nextMsg() != 0){
            opponentProx4.getFloat() => float opp1;
            opponentProx4.getFloat() => float opp2;
            opponentProx4.getFloat() => float opp3;
            proxAlarm.alarm(opp1, opp2, opp3);
        }
    }   
}

fun void explosionPoll(){
    while(1){
        explosion => now;
        if (explosion.nextMsg() != 0){
            explosion.getInt() => int ex;
            if (ex == 1){
            boom.impact();  
            <<<"Explosion">>>; 
        }
        else if (ex == 2){
            announcer.announceOppKill();
        }
        else{
         <<<"Invalad Message on explosion OSC path", explosion.nextMsg() >>>;  
        }
        }   
    }   
}

fun void newPlayerPoll(){
    while(1){
        newPlayer => now;
        if (newPlayer.nextMsg() != 0){
            announcer.announceNewPlayer();   
            <<<"New player">>>;
        }   
    }
}
fun void playerKillListen() {
    while(true){
        playerKilled => now;
        if (playerKilled.nextMsg() != 0) {
            playerKilled.getString() => string playerPre;
            <<<playerPre + " killed!">>>;
            if (playerPre == myPrefix)
            {
                0 => runState;
                walking.dead();
                scream.killed();
                0.45::second => now;//for reverb tail
                scream.dead();
                sendRespawnPing();
                walking.alive();
            }
        }
    }   
}
fun void serialPoller(){
    while( true )
    {
        serial.onLine() => now;
        serial.getLine() => line;
        if( line$Object == null ) continue;
        if (line.length() > 22){ 
            line.substring(0,3) => x_axisS;
            Std.atoi(x_axisS) - 200 => x_axis; 
            line.substring(4,3) => y_axisS;
            Std.atoi(y_axisS) - 200 => y_axis;
            line.substring(8,3) => x_accS;
            Std.atoi(x_accS) - 500 => x_acc;
            line.substring(12,3) => y_accS;
            Std.atoi(y_accS) - 500 => y_acc;
            line.substring(16,3) => z_accS;
            Std.atoi(z_accS) - 500 => z_acc;
            line.substring(20,1) => z_buttonS;
            Std.atoi(z_buttonS) => z_button ;
            if ( z_button > 0){
                if (runState ==1){
                spork ~ sendZButtonData();  
            }
            }
            line.substring(22,1) => c_buttonS;
            Std.atoi(c_buttonS) => c_button;
            if( c_button > 0)
            { 
                if (runState == 1){
                spork ~ sendCButtonData();
            }
            }
        }
        else{
         <<<"Error, Serial Message too short">>>;   
        }
    }
}

//////////     **********UTILITY FUNCTIONS*********     \\\\\\\\\\
fun void aDif(){
    Std.abs(125 - x_axis) => xDiff;
    Std.abs(125 - y_axis) => yDiff;
    (xDiff + yDiff)/2 => aDiff;  
    //<<<aDiff>>>;
}