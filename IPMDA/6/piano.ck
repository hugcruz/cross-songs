// piano.ck
<<< "IPMDA Assignment 6 - Cross Song 6: Piano" >>>;

/* ******************************** */
/* SOUND CHAIN, NOTES AND DURATIONS */
/* ******************************** */

Rhodey piano[3];

0.625::second => dur quarter;
quarter/2 => dur eighth;
quarter/4 => dur sixteenth;
quarter*2 => dur half;

[46, 48, 49, 51, 53, 54, 56, 58, 60, 61, 63, 65, 66, 68, 70] @=> int scale[];

[6, -1, 6, -1,
 6, -1, 6,
 0, 2,
 6, -1, 6, -1,
 6, -1, 6,
 7, 6, 5, 4,
 6, -1, 6, -1,
 6, 6, 6, 6, 6
 ] @=> int notes[];
 
[quarter, quarter, quarter, quarter,
 quarter, quarter, quarter,
 eighth, eighth,
 quarter, quarter, quarter, quarter,
 quarter, quarter, quarter,
 sixteenth, sixteenth, sixteenth, sixteenth,
 quarter, quarter, quarter, quarter,
 eighth, eighth, eighth, eighth, half
 ] @=> dur noteDurations[];


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
    noteDurations[i%noteDurations.cap()] => now;
    
    //increment index
    1+=>i;
}

/* ********* */
/* FUNCTIONS */
/* ********* */

//initialize UGens
fun void init() {
    for ( 0 => int i; i < piano.cap(); i++ ) {
        piano[i] => dac;
        0.75 / piano.cap() / (i+1) => piano[i].gain;
    }    
}

//Play chord in UGens
fun void play(int note) {
    Std.mtof(scale[note]-12) => piano[0].freq;
    Std.mtof(scale[note+3]-12) => piano[1].freq;
    Std.mtof(scale[note+7]-12) => piano[2].freq;
    
    //noteOn value is random but the same for all UGens
    Math.random2f( 0.6, 0.8 ) => float noteOn;
    noteOn => piano[0].noteOn => piano[1].noteOn => piano[2].noteOn;
}