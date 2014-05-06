public class Scream{
    
    
    
    
    adc => Gain meter => LiSa recording => dac;
   
    0 => int recTime;
    float currentLevel;
    0 => int gate;
    5::second => recording.duration;
   
   1 => recording.rate;
   
    
    fun void meterPoll(){
        while(1){
            <<<Std.fabs(meter.last())>>>;
            100::ms => now;   
        }
    }
    
    fun void killed(){
        <<<"Playing Back Recording">>>;
        recording.playPos(0::ms);
        recording.play(1);   
        recTime*0.2::second => now;
        0 => gate;
        recording.play(0);
        recording.clear();
        recording.rampUp(100::ms);
    }
    
    fun void dead(){
       0 =>  recTime;
        while (gate < 1){
            
            <<<"Scream to Respawn">>>;
            if (meter.last() > 0.7){
               recording.clear();
                recording.record(1);
                <<<"Started Recording">>>;
                while(Std.fabs(meter.last()) > 0.03){
                    0.2::second => now; 
                    recTime++;  
                    <<<"Recording">>>;
                }   
                recording.record(0);
                gate++;
            }
            10::ms => now;
        }
        <<<"Dead Loop Ended">>>;
       
    }
}
