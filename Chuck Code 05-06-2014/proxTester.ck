proxAlarms alarm;

while(1){
    for(0 => int i; i < 20; i++){
        alarm.alarm(i* 0.057, 0.1,i * 0.015 );
        100::ms => now;
        <<<i* 0.047 , 0.1,i * 0.015>>>;
    }
}