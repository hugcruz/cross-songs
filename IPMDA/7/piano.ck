// piano.ck
<<< "IPMDA Assignment 7 - Cross Song 7: Piano" >>>;

/* ******************************** */
/* SOUND CHAIN, NOTES AND DURATIONS */
/* ******************************** */

Rhodey piano;

[48, 50, 52, 53, 55, 57, 59, 60] @=> int scale[];

//notes to be played (-1 is silence)
[-1, -1, -1, -1,
 5, 1, 5, 1,
 7, 3, 3, 0,
 0, 3, 5, 7,
 7, 1, 3, 5, 7,
 0, 6, 4, 2, 0,
 7, 5, 3, 1
 ] @=> int notes[];
 
//array of durations just to make the next array easier to read
[BPM.quarterNote*2, BPM.quarterNote, BPM.eighthNote, BPM.sixteenthNote] @=> dur timeArray[];

//duration for each note
[0, 0, 0, 0,
 0, 0, 0, 0,
 0, 0, 0, 0,
 2, 2, 2, 2,
 0, 2, 2, 2, 2,
 0, 2, 2, 2, 2,
 2, 2, 2, 2
] @=> int noteDurations[];


/* ************ */
/* MAIN SECTION */
/* ************ */
init();

0=>int i;
while(true){
    //select note to play
    notes[i%notes.cap()] => int note;
    if(note != -1){
        play(note);
    }
    
    //durations taken from the array
    timeArray[noteDurations[i%noteDurations.cap()]] => now;
    
    //increment index
    1+=>i;
}

/* ********* */
/* FUNCTIONS */
/* ********* */

//initialize Piano
fun void init() {
    piano => JCRev rev => MasterPan.pan;
    0.25=>rev.mix;
    0.15 => piano.gain;    
}

//Play chord in Piano
fun void play(int note) {
    Std.mtof(scale[note]) => piano.freq;
    
    //noteOn value is random
    Math.random2f( 0.6, 0.8 ) => piano.noteOn;
}