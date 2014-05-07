// serial handling
SerialIO serial;
string line;//the data comming in
"/tweez" => string myPrefix;

//osc info to send messages for player respawn
//set up OSC to send info
OscSend xmit;
xmit.setHost("localhost",14001);
//set up OSC to look for messages
OscRecv oscIn;
14000 => oscIn.port;
//for when the player hits an object with the axe
oscIn.listen();

int x_axis;
int y_axis;
int x_acc;
int y_acc;
int z_acc;
int z_button;
int c_button;
string x_axisS, y_axisS ,x_accS ,y_accS, z_accS,z_buttonS,c_buttonS;
//lists serial ports
SerialIO.list() @=> string list[];
for( int i; i< list.cap(); i++ )
{
    chout <= i <= ": " <= list[i] <= IO.newline();
    //5::second => now;
}
//opens serial ports
serial.open(4, SerialIO.B9600, SerialIO.ASCII);


1::second => now;//to make sure program does not initalize in the middle of a message
spork ~ serialPoller();
spork ~ sendJoyData();
spork ~ sendAccData();

while (true) {
    <<<"x_axis :", x_axis>>>;
    <<<"y_axis :", y_axis>>>;
    <<<"x_acc :", x_acc>>>;
    <<<"y_acc :", y_acc>>>;
    <<<"z_acc :", z_acc>>>;
    <<<"-------------------------">>>;
    
    .5::second => now; 
}

fun void sendJoyData(){
    while(1){
        xmit.startMsg("/nunchuck/joystick", "i,i");
        xmit.addInt(x_axis);
        xmit.addInt(y_axis);
        //<<<"joystick data sent">>>;
        10::ms => now;// to not overload chuck
    }
}

fun void sendAccData(){
    while(1){
        xmit.startMsg("/nunchuck/accel", "i,i,i");
        xmit.addInt(x_acc);
        xmit.addInt(y_acc);
        xmit.addInt(z_acc);
        10::ms => now;
    }
}

fun void sendCButtonData(){
        xmit.startMsg("/nunchuck/Cbutton", "i"); 
        xmit.addInt(c_button);  
        10::ms => now;   
        <<<"C Button Pressed">>>;    
}

fun void sendZButtonData(){//the melee attack
    xmit.startMsg("/nunchuck/Zbutton", "i"); 
    xmit.addInt(z_button);
    10::ms => now;   
    <<<"Z Button Pressed">>>;
    
}

fun void serialPoller(){
    
    while( true )
    {
        // grab serial data
        serial.onLine() => now;
        serial.getLine() => line;
        // <<<line>>>;
        if( line$Object == null ) continue;
        //<<<"entered if">>>;
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
                spork ~ sendZButtonData();  
            }
            line.substring(22,1) => c_buttonS;
            Std.atoi(c_buttonS) => c_button;
            if( c_button > 0)
            { 
                spork ~ sendCButtonData();
            }
        }
    }
}