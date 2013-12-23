/* ******************************************** */
/* CROSS SONG 3                                 */
/*                                              */
/* Duration: 30 seconds                         */
/* Use of:                                      */
/* - array of string with sound files           */
/* - reverse at least one sound (negative rate) */
/* - modulus                                    */
/* - 50, 52, 53, 55, 57, 59, 60, 62 or +-12     */
/* - quarter notes (0.25 seconds)               */
/* - Oscillator                                 */
/* - SndBuf                                     */
/* - if/else                                    */
/* - variables                                  */
/* - comments                                   */
/* - Std.mtof()                                 */
/* - Random number                              */
/* - Panning                                    */
/* ****************************************** */

<<< "IPMDA Assignment 3 - Cross Song 3" >>>;

//get sound at the begining
now => time startTime;

/* *********************** */
/* SOUND NETWORK AND SETUP */
/* *********************** */
Gain master => Pan2 pan => dac;
SndBuf beat1 => master;
SndBuf beat2 => master;
SndBuf fx => master;
SinOsc melody => master;

//set better names for durations
0.25::second => dur quarter;
0.50::second => dur half;

//set initial gains
0.3 => beat1.gain;
0.3 => beat2.gain;
0.3 => melody.gain;


/* ************************ */
/* FILES AND SEQUENCE ARRAYS*/
/* ************************ */

//files
me.dir() => string path;
[
path + "/audio/kick_01.wav",
path + "/audio/snare_01.wav",
path + "/audio/cowbell_01.wav",
path + "/audio/hihat_01.wav",
path + "/audio/stereo_fx_05.wav"
] @=> string files[];

//beat -> quarter notes -> 2 seconds
[0, -1, 1, 0, -1, 1, 0, 0] @=> int beat[];

//fill -> quarter notes -> 8 seconds
[-1, 2, 3, -1, 2, 3, -1, -1,
 -1, 2, 3, -1, 2, 3, -1, -1,
 -1, 2, 3, -1, 2, 3, -1, -1,
 2, -1, 2, -1, 2, -1, 2, -1] @=> int lineFill[];
 
//intro -> half notes -> 2 seconds
[50, 53, 57, 60] @=> int notesIntro[];

//melody -> quarter notes -> 8 seconds
[50, 00, 50, 53, 00, 53, 50, 57,
 50, 00, 50, 53, 00, 53, 50, 57,
 50, 00, 50, 53, 00, 53, 50, 57,
 50, 50, 53, 53, 57, 57, 60, 60] @=> int notesMelody[]; 
 
//melody variation -> quarter notes -> 2 seconds
[50, 00, 53, 50, 00, 53, 50, 50] @=> int notesMelody2[]; 


/* ***** */
/* INTRO */
/* ***** */
0 => int i;
for(0 => int i; i<4; ++i){
    files[beat[0]] => beat1.read;
    0 => beat1.pos;
    
    Std.mtof(notesIntro[i]) * 2 => melody.freq;
    pan.pan(Math.random2(-1,1));
    
    half => now;
}


/* ************************ */
/* MAIN SECTION             */
/*                          */
/* Main melody              */
/* Variation of main melody */
/* Beat                     */
/* Fill                     */
/* Effect                   */
/* ************************ */
pan.pan(0);
0 => melody.freq;
0 => i;

while(i<notesMelody.cap()*3) {
    //always loop beat
    if(beat[i%beat.cap()] != -1) {
        files[beat[i%beat.cap()]] => beat1.read;
        0 => beat1.pos;
    }
    
    //on first and second "run", play melody
    if(i/notesMelody.cap()<2){
        Std.mtof(notesMelody[i%notesMelody.cap()]) * 2 => melody.freq;
    } else {
        0 => melody.freq;
    }
    
    //on second and third "run", play beat fill
    if(i/notesMelody.cap()>=1){
        if(lineFill[i%lineFill.cap()] != -1) {
            files[lineFill[i%lineFill.cap()]] => beat2.read;
            0 => beat2.pos;
        }
    }
    
    //on third run, play fx and variation of the melody
    if(i/notesMelody.cap()==2){
        //start playing with third run
        if(i%notesMelody.cap()==0){
            0.5 => fx.gain;
            files[4] => fx.read;
            0 => fx.pos;
            1 => fx.rate;
        } else {
            //reverse every second
            if(i%4==0){
                fx.rate() * -1 => fx.rate;
            }
        }
        
        //variation of melody
        Std.mtof(notesMelody2[i%notesMelody2.cap()]) * 2 => melody.freq;
    }
    
    //go forward 0.25 seconds
    quarter => now;
    ++i;
}

//mute effects and fill
0 => fx.gain;
0 => beat2.gain;


/* ***** */
/* OUTRO */
/* ***** */
for(0 => i; i<8; ++i){
    //play reversed cowbell 7 times
    if(i<7){
        files[2] => beat1.read;
        beat1.samples() => beat1.pos;
        -1.0 => beat1.rate;
    }
    
    //play same line as in intro
    Std.mtof(notesIntro[i%notesIntro.cap()]) * 2 => melody.freq;
    
    pan.pan(Math.random2(-1,1));
    
    half => now;
}

<<<"Final time is: " + (now - startTime)/second>>>;