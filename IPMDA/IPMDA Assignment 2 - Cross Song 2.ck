/* **************** */
/* Cross Song 2
/* I am using:
/*  - TriOsc, SinOsc and SawOsc
/*  - Arrays
/*  - Panning
/*  - Random numbers: Math.random2f
/*  - Midi notes: Std.mtof
/*  - D Dorian scale: 50, 52, 53, 55, 57, 59, 60, 62
/*  - Base octave and one above (freq * 2)
/*  - Quarter notes
/* **************** */
//50, 52, 53, 55, 57, 59, 60, 62

//Title
<<< "IPMDA Assignment 2 - Cross Song 2" >>>;

//get sound at the begining
now => time startTime;

/* ************* */
/* SOUND NETWORK */
/* ************* */
TriOsc loop => dac;
SinOsc melody => dac;
SawOsc saw => Pan2 pan => dac;

//start only with loop
0.4=>loop.gain;

//mute the rest
0=>saw.gain;
0=>melody.gain;


/* **************** */
/* MIDI NOTE ARRAYS */
/* **************** */

[57, 57, 50, 50, 62, 50, 62, 50,
 59, 59, 55, 57, 60, 55, 55, 57
 ] @=> int notesLoop[]; //4 seconds

[62, 62, 60, 57, 59, 59, 57, 60,
 60, 62, 57, 57, 62, 59, 60, 60,
 62, 62, 60, 57, 60, 60, 59, 60,
 60, 62, 57, 57, 62, 57, 62, 62
 ] @=> int notesMelody[]; //8 seconds

[62, 00, 62, 57, 00, 57, 00, 60,
 00, 60, 00, 55, 00, 55, 00, 60,
 62, 50, 62, 57, 50, 57, 50, 60,
 50, 60, 50, 55, 50, 55, 50, 62,
 62, 00, 62, 57, 00, 57, 00, 60,
 00, 60, 00, 55, 00, 55, 00, 60,
 62, 00, 62, 57, 00, 62, 57, 00,
 00, 60, 62, 55, 57, 55, 50, 62
 ] @=> int notesSaw[]; //16 seconds

/* ******************* */
/* AUXILIARY VARIABLES */
/* ******************* */

//set time unit to a better name
0.25::second => dur quarter;

//positions in array
0 => int position;
0 => int positionMelody;
0 => int positionSaw;

/* ******************************** */
/* START WITH LOOP - 0 to 4 seconds */
/* ******************************** */

while(position<notesLoop.cap()){
    //set frequency to play
    Std.mtof(notesLoop[position])=>loop.freq;
    
    //move to next position
    ++position;

    //play
    quarter=>now;
}

/* ***************************************** */
/* ADD MELODY IN CRESCENDO - 4 to 12 seconds */
/* ***************************************** */

//reset loop
0 => position;

while(positionMelody < notesMelody.cap()){
    //set frequencies to play
    Std.mtof(notesLoop[position]) => loop.freq;
    Std.mtof(notesMelody[positionMelody]) * 2 => melody.freq;
    
    //move to next position
    ++position;
    ++positionMelody;
    
    //reset loop
    if(position==notesLoop.cap()){
        0 => position;
    }
    
    //set crescendo from 0 to 0.3
    0.3 * positionMelody / notesMelody.cap() => melody.gain;

    //play
    quarter=>now;
}

/* ***************************************** */
/* STOP MELODY, START SAW - 12 to 28 seconds */
/* ***************************************** */

//reset loop
0 => position;

//start saw
0.2=>saw.gain;

while(positionSaw < notesSaw.cap()){
    //set frequencies to play
    Std.mtof(notesLoop[position]) => loop.freq;
    Std.mtof(notesSaw[positionSaw]) => saw.freq;
    
    //set saw to random left/right channels
    pan.pan(Math.random2f(-1,1));
    
    //move to next position
    ++position;
    ++positionSaw;
    
    //reset loop
    if(position==notesLoop.cap()){
        0 => position;
    }
    
    //play
    quarter=>now;
}

/* ******************************** */
/* FADE OUT BUZZ - 28 to 30 seconds */
/* ******************************** */
pan.pan(0);

for(0=>int i; i<8; ++i){
    //set gains for fade out
    0.3 * (8-i-1)/7 => loop.gain;
    0.3 * (8-i-1)/7 => melody.gain;
    0.2 * (8-i-1)/7 => saw.gain;
    
    //play
    quarter=>now;
}

<<<"Final time is: " + (now - startTime)/second>>>;