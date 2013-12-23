//Title
<<< "IPMDA Assignment 1 - Cross Song 1" >>>;

/* ************************************************************ */
/* It was a challenge to deal with the limitations for week 1:  */
/* The code would look much better with arrays and modules.     */
/* I decided to go for readability over efficiency in the code. */
/* The "composition" has 2 sections:                            */
/* 1. A spinning and accelerating sound, like a cymbal falling. */
/*    I play with the frequency by playing with start and end   */ 
/*    frequency, speed of update and increments/decrements.     */
/* 2. A beat and "melody" section. This code would look much    */
/*    better with arrays but I did it with if statements. It    */
/*    loops twice and has 8 lines of 19 "beats".                */
/* ************************************************************ */

//get sound at the beggining
now => time startTime;

//sound network
SinOsc wave => dac;
TriOsc melody => dac;
SqrOsc beat => dac;

//set gains for section 1 (only Sin)
0   => beat.gain;
0   => melody.gain;
0.4 => wave.gain;

//set variables for "spinning" sound
0  => int cicle;     //current cicle
15 => int numCicles; //number of cicles
1  => int up;        //are we going "up" in the frequencies

2   => float speed;  //starting speed
250 => float start;  //low (start) frequency for first cicle
400 => float end;    //high (end) frequency for first cicle

start => float freq; //starting frequency

//go through cicles
while(cicle <= numCicles) {
    //set frequency for sin wave
    freq => wave.freq;
    
    //are we going "up"?
    if(up == 1) {
        //increase frequency with speed
        speed +=> freq;
        
        //when we reach the target high frequency, go down
        //target frequency goes up with every cicle
        if(freq >= (end + cicle * start)){
            0=>up;
        }
    }
    else{
        //decrease frequency
        speed -=> freq;
        
        //when we reach the target low frequency, go up in next cicle
        //target frequency goes up with every cicle
        if(freq <= (cicle+1.1) * start){
            cicle++;
            1=>up;
            //limit top speed so it sounds better
            if(speed<50){
                1.5*=>speed;
            }
        }
    }
    
    //play
    0.01::second => now;
}

//small pause between sections
0.01::second => now;


//set gains for section 2
0.3 => beat.gain;
0.3 => melody.gain;

//loop twice on 8 lines and 19 beats
for(0 => int loop; loop < 2; loop++){
    for(0 => int line; line < 8; line++){
        for( 0 => int i; i < 19; i++ )
        {
            /* **** */
            /* Beat */
            /* **** */
            if(i==2  || i==3  ||
               i==6  || i==7  ||
               i==10 || i==11 ||
               i>=14){
                //beats 2, 3, 6, 7, 10, 11 and after 13 are pauses
                0 => beat.freq;
            }
            else {
                //every two lines, the frequency changes
                if(line<=1)           { 100 => beat.freq; }
                if(line==2 || line==3){ 120 => beat.freq; }
                if(line==4 || line==5){ 80  => beat.freq; }
                if(line>=6)           { 95  => beat.freq; }
            }
            
            /* ****** */
            /* Melody */
            /* ****** */
            
            //lines 0, 2, 4 and 5 are a simple frequency
            //lines 1, 3, 5 and 7 start have a sequence of two frequencies and then silence
            if(line==0)           { 880 => melody.freq;  }
            if(line==1){
               if(i<=3)           { 440 => melody.freq;  }
               if(i>3 && i<=14)   { 660 => melody.freq;  }
               if(i>=16)          { 0   => melody.freq;  }
            }
            if(line==2)           { 990 => melody.freq;  }
            if(line==3){
               if(i<=3)           { 550 => melody.freq;  }
               if(i>3 && i<=14)   { 770 => melody.freq;  }
               if(i>=16)          { 0   => melody.freq;  }
            }
            if(line==4 || line==6){ 1100 => melody.freq; }
            if(line==5 || line==7){
               if(i<=3)           { 660 => melody.freq;  }
               if(i>3 && i<=14)   { 550 => melody.freq;  }
               if(i>=16)          { 0   => melody.freq;  }
            }
            
            /* **** */
            /* Wave */
            /* **** */
            //don't play in the first interaction of loop
            if(loop==0) { 0=>wave.freq; }
            //second interaction:
            //start at 500
            //first 4 lines, go up 20 every 0.075 seconds
            //last 4 lines, go down 20 every 0.075 seconds
            if(loop==1) {
               if(line==0 && i==0) { 500=>freq; }
               if(line<=3)         { 20+=>freq; }
               if(line>=4)         { 20-=>freq; }
               
               freq=>wave.freq;
            }

            /* **** */
            /* Play */
            /* **** */
            0.075::second => now;
        }
    }
}

<<<"Final time is: " + (now - startTime)/second>>>;