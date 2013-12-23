// piano.ck
<<< "IPMDA Assignment 8 - Cross Song 8: Piano" >>>;

/* ******************************** */
/* SOUND CHAIN, NOTES AND DURATIONS */
/* ******************************** */

Rhodey piano;

[48, 50, 52, 53, 55, 57, 59, 60] @=> int scale[];

//notes to be played
[2,2,2,2,
 5,5,4,4,
 1,1,1,1,
 5,5,4,4,
 0,0,0,0,
 3,3,4,4,
 1,1,1,1,
 4,4,6,6
 ] @=> int melody[];


/* ************ */
/* MAIN SECTION */
/* ************ */
init();

0=>int i;

while(true){
    //select note to play
    melody[i%melody.cap()] => int note;
    play(note);
    
    BPM.quarterNote => now;
    
    //increment index
    1+=>i;
}

/* ********* */
/* FUNCTIONS */
/* ********* */

//initialize Piano
fun void init() {
    piano => JCRev rev => MasterPan.pan;
    0.25 => rev.mix;
    0.15 => piano.gain;    
}

//Play chord in Piano
fun void play(int note) {
    Std.mtof(scale[note]-12) => piano.freq;
    
    //noteOn value is random
    Math.random2f( 0.6, 0.8 ) => piano.noteOn;
}