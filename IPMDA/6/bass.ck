// bass.ck
<<< "IPMDA Assignment 6 - Cross Song 6: Bass" >>>;

/* ******************************** */
/* SOUND CHAIN, NOTES AND DURATIONS */
/* ******************************** */

TriOsc osc[2];
ADSR env => Gain o => LPF f => Pan2 pan => dac;

0.625::second => dur quarter;
quarter/2 => dur eighth;

[46, 48, 49, 51, 53, 54, 56, 58] @=> int scale[];
[7, 6, 5, 4, 3, 2, 1, 1, 1, 0, 1, 2, 3, 4, 5, 6, 6, 6] @=> int walk[];

/* ************ */
/* MAIN SECTION */
/* ************ */
init();

0=>int i;
while(true){
    //set note to be played
    play(scale[walk[i%walk.cap()]]-24);
    
    //some changes of timing
    //each loop has 14 quarter notes and 4 eighth notes
    //each loop lasts 16 quarter: 10 seconds
    if(    (i%walk.cap()) == 7
        || (i%walk.cap()) == 8
        || (i%walk.cap()) == 16
        || (i%walk.cap()) == 17){
        eighth => now;
    } else {
        quarter => now;
    }
    
    //start fadeout on third loop: when i/walk.cap()==2
    //stop decrementing the gain when it reaches 0
    if(i/walk.cap()==2 && o.gain()!=0.0){
         o.gain() - 0.1 => o.gain;
    }
    
    //increment index
    1+=>i;
}

/* ********* */
/* FUNCTIONS */
/* ********* */

fun void init() {
    0.3=>pan.pan;

    // set envelope 
    (0.05::second, 0.7::second, 0.2, 0.0001::second) => env.set;

    0.7 => o.gain;
    1200  => f.freq;
    3 => f.Q;

    for ( 0 => int i; i < osc.cap(); i++ ){
        osc[i] => env;
        1.0 / osc.cap() / (i+1) => osc[i].gain; 
    }
}

// bass function 
fun void play (int note)
{
    Std.mtof(note) => osc[0].freq;
    Std.mtof(note + 12) => osc[1].freq;
    1 => env.keyOn;
}