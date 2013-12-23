/* ******************************************** */
/* CROSS SONG 5                                 */
/* Better enjoyed with headphones for better    */
/* bass and stereo experience                   */
/*                                              */
/* Duration: 30 seconds                         */
/* Use of:                                      */
/* - Oscillator                                 */
/* - SndBuf                                     */
/* - STK instruments: voice, moog & mandolin    */
/* - if/else                                    */
/* - loops                                      */
/* - variables                                  */
/* - comments                                   */
/* - Std.mtof()                                 */
/* - Random number                              */
/* - arrays                                     */
/* - Panning                                    */
/* - Main beat: 0.75 seconds                    */
/* - 49, 50, 52, 54, 56, 57, 59, 61 or +-12     */
/* - Functions                                  */
/* ******************************************** */

<<< "IPMDA Assignment 5 - Cross Song 5" >>>;

//get sound at the begining
now => time startTime;

/* *********************** */
/* SOUND NETWORK AND SETUP */
/* *********************** */

SndBuf beat[2];
Mandolin chord[3];
SinOsc osc => dac;
//Voices connected to a Pan2 instance
VoicForm voice => Pan2 panVoice => dac;
//Moog played through a JCRev filter and with Pan
Moog moog => JCRev moogRev => Pan2 moogPan => dac;
//Chords will be connected to the Pan later
Pan2 chordsPan => dac;

//initial conditions
-0.5 => moogPan.pan;
0.5 => chordsPan.pan;
0.25 => moog.gain;

0=>osc.freq;
0.2=>osc.gain;

voice.phoneme("ooo");

//set better names for durations
0.75::second => dur quarter;

/* ************************ */
/* FILES AND SEQUENCE ARRAYS*/
/* ************************ */

//files
me.dir() => string path;
[
path + "/audio/kick_01.wav",
path + "/audio/hihat_01.wav"
] @=> string files[];

//Eb Mixolydian scale
[49, 50, 52, 54, 56, 57, 59, 61] @=> int scale[];

//bass (sinOsc)
[0, 2, 4, 0, 2, 4, 3, 0, 2, 4, 1, 3, 0, 4, 2, 4] @=> int bass[];

//moog
[-1, -1, -1, 0, -1, 0, 0, 0, 0, 2, 5, 3,  3,
  2, 4,  6, 4,  2, 3,  3, 3, 5, 3, 2, 5, 4,
  2, 5,  6, 4,  2, 0 ] @=> int mainMelodyMoog[];

//mandolin
[-1, 0, 0, 0, -1, 0, 0, 0, 0, 7, 6, 5, 7,
  7, 6,  6, 4,  2, 5,  7, 7, 6, 6, 7, 5, 7,
  6, 5,  6, 4,  2, 0 ] @=> int mainMelodyMandolin[];

//drums
//index 0: bass
//index 1: hihat
[[1.],[0.,1,0,1]] @=> float drums[][];

/* ************ */
/* Main section */
/* ************ */

//initialize sound network
initChords(chord);
initBeat(beat);
setVolume(chord, 0.15);

//start voice
1.0=>voice.speak;

int i;
//intro - beat and reversed hihat - 3 seconds
for(0 => i; i<4; ++i){
    playBeat(i, 1);
    
    quarter => now;
}

//main section - 24 seconds
for(0 => i; i<mainMelodyMoog.cap(); ++i){
    //play only bass drum
    playBeat(i,0);
    
    //pan the voice slowly between the channels and randomize gain
    Math.sin(i*2*Math.PI/36) => panVoice.pan;
    Math.random2f(0.5, 1.0) => voice.speak;
    
    //Play moog
    if(note(mainMelodyMoog,i)!=-1){
        Std.mtof(scale[note(mainMelodyMoog,i)])=>moog.freq;
        Math.random2f(0.7, 1.0) => moog.noteOn;
    } else {
        1.0 => moog.noteOff;
    }
    
    //Play mandolin
    playChord(chord, note(mainMelodyMandolin,i), 0);
    
    //Play bass
    if(i>8 && i%2==1){
        Std.mtof(scale[note(bass, (i-8)/2)]) => osc.freq;
    }
    
    quarter => now;
}

//outro - 3 seconds

//stop moog
1 => moog.noteOff;

//set voice to expected value (previously set to a random number)
1.0 => voice.speak;
for(0 => i; i<4; ++i){
    //don't play beat in last 0.75, just let previous sounds end
    if(i!=3){
        playBeat(i, 1);
    }
    
    //fade out osc and voice
    0.2*(4-i)/4 => osc.gain;
    (4-i)/4 => voice.speak;
    (4-i)/4 => voice.gain;
        
    quarter => now;
}

<<<"Final time is: " + (now - startTime)/second>>>;

/* ******** */
/* Funtions */
/* ******** */

//get a note from an array
//takes care of looping through the arrays
fun int note(int sequence[], int i){
    return sequence[i%sequence.cap()];
}

// initialize array of Mandolins for chords
fun void initChords(Mandolin mand[]){
    for(0=> int i; i< mand.cap(); i++){
        mand[i] => chordsPan;
        0 => mand[i].gain;
        0.1 => mand[i].stringDamping;
    }
}

// initialize SndBuf array for beat
fun void initBeat(SndBuf buffer[]){
    for(0=> int i; i< buffer.cap(); i++){
        files[i] => buffer[i].read;
        if(i==0){
            //pass the bass drum through a NRev filver
            buffer[i] => NRev rev => dac;
            0.6 => rev.mix;
            0.5 => buffer[i].rate;
        }
        if(i==1){
            buffer[i] => dac;
        }
        0.5=> buffer[i].gain;
    }
}

//play chord: root note, +3 and +7
//gets root from scale array
//octave to add a fixed value to all the notes in the chord
fun void playChord(Mandolin mand[], int i, int octaves){
    if(i != -1){
        Std.mtof(scale[i] + octaves) => mand[0].freq;
        Std.mtof(scale[i] + 3 + octaves) => mand[1].freq;
        Std.mtof(scale[i] + 7 + octaves) => mand[2].freq;
    
        Math.random2f(0.75,0.95) => mand[0].pluck => mand[1].pluck => mand[2].pluck;
    }
}

//play beat
fun void playBeat(int index, int max){
    for(0=>int i; i<drums.cap() && i<=max; ++i){
        if(drums[i][index%drums[i].cap()]!=0){
             
            if(i==0){
                0 => beat[i].pos;
            } else{
                //reverse hihat
                beat[i].samples() => beat[i].pos;
                -1.0 => beat[i].rate;
            }
                
            //randomize drum gain in order to give it a more natural feel
            Math.random2f(0.3,0.4) * drums[i][index%drums[i].cap()] => beat[i].gain;
        }
    }
}

//sets volume of chords
fun void setVolume(Mandolin mand[], float volume){
    for(0=> int i; i< mand.cap(); i++){
        volume => mand[i].gain;
    }
}