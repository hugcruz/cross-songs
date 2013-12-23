/* ******************************************** */
/* CROSS SONG 4                                 */
/*                                              */
/* Duration: 30 seconds                         */
/* Use of:                                      */
/* - arrays                                     */
/* - modulus                                    */
/* - 51, 53, 55, 56, 58, 60, 61, 63 or +-12     */
/* - Main beat: 0.6 seconds                     */
/* - Oscillator                                 */
/* - SndBuf                                     */
/* - if/else                                    */
/* - variables                                  */
/* - comments                                   */
/* - Std.mtof()                                 */
/* - Random number                              */
/* - Panning                                    */
/* - Functions                                  */
/* ******************************************** */

<<< "IPMDA Assignment 4 - Cross Song 4" >>>;

//get sound at the begining
now => time startTime;

/* *********************** */
/* SOUND NETWORK AND SETUP */
/* *********************** */
Pan2 pan => dac;
SndBuf beat[3];
TriOsc chord[3];
SinOsc sin => dac;

//set better names for durations
0.6::second => dur quarter;
0.3::second => dur eigth;

/* ************************ */
/* FILES AND SEQUENCE ARRAYS*/
/* ************************ */

//files
me.dir() => string path;
[
path + "/audio/kick_01.wav",
path + "/audio/snare_01.wav",
path + "/audio/hihat_01.wav"
] @=> string files[];

//Eb Mixolydian scale
[51, 53, 55, 56, 58, 60, 61, 63] @=> int scale[];

//circular sequence for chords
[0, 3, 6, 2, 5, 1, 4] @=> int mainMelody[];

//drums
//index 0: bass
//index 1: snare
//index 2: hihat
[[1.],[1.5,0,1.5,0,0,1.5,1.5,0],[0.,1,0,1,1,0,0,1]] @=> float drums[][];

//melody
//each position hsa one array of notes for a sequence (playMain function)
//-1 to mute
int melody[3][28];
[-1,-1,-1,-1, 0, 1, 2,
  3, 7, 6, 5, 5, 5, 7,
  6, 7, 5, 7, 4, 4, 1,
  1, 5, 5, 7, 4, 5, 1] @=> melody[0];
  
[ 1, 3, 3, 1, 1, 3, 3,
  5, 6, 7, 5, 7, 6, 4,
  4, 3, 5, 5, 3, 6, 6,
  2, 5, 6, 2, 7, 7, 4] @=> melody[1];
  
[ 6, 7, 4, 4, 7, 5, 5,
  3, 7, 5, 0, 0, 7, 2,
  4, 5, 5, 7, 7, 2, 1,
  7, 6, 5, 4, 3, 2, 1] @=> melody[2];

/* ************ */
/* Main section */
/* ************ */

//initialize sound network
initChords(chord);
initBeat(beat);

//intro: 2.4 seconds
playIntro(4);

//main section: 8.4 seconds per call (14 quarter notes or 28 eight notes)
playMain(4, 0, 0);
playMain(4, 1, 1);
playMain(4, 0, 2);

//outro: 2.4 seconds
playOutro(4);

<<<"Final time is: " + (now - startTime)/second>>>;

/* ******** */
/* Funtions */
/* ******** */

// initialize array of osc for chords
fun void initChords(TriOsc sins[]){
    for(0=> int i; i< sins.cap(); i++){
        sins[i] => pan;
        0.1=> sins[i].gain;
    }
}

// initialize SndBuf array for beat
fun void initBeat(SndBuf buffer[]){
    for(0=> int i; i< buffer.cap(); i++){
        files[i] => buffer[i].read;
        buffer[i] => dac;
        0.1=> buffer[i].gain;
    }
}

//play chord: root note, +3 and +7
//gets root from scale array
//octave to add a fixed value to all the notes in the chord
fun void playChord(TriOsc sins[], int i, int octaves){
    Std.mtof(scale[i] + octaves) => sins[0].freq;
    Std.mtof(scale[i] + 3 + octaves) => sins[1].freq;
    Std.mtof(scale[i] + 7 + octaves) => sins[2].freq;
}

//play beat
fun void playBeat(int index){
    for(0=>int i; i<drums.cap(); ++i){
        if(drums[i][index%drums[i].cap()]!=0){
            0 => beat[i].pos;
            //randomize drum gain in order to give it a more natural feel
            Math.random2f(0.2,0.3) * drums[i][index%drums[i].cap()] => beat[i].gain;
        }
    }
}

//sets volume of chords
fun void setVolume(TriOsc sins[], float volume){
    for(0=> int i; i< sins.cap(); i++){
        sins[i] => dac;
        volume => sins[i].gain;
    }
}

//play intro
//only bass drum
fun void playIntro(int duration){
    //mute sin melody
    0.0=>sin.gain;
    
    //mute chord
    setVolume(chord, 0);
    
    for(0=> int i; i < duration; i++){
        //play bass drum as quarter note
        0 => beat[0].pos;
        quarter=>now;
    }
}

//play main section: beat, chord and sin melody
//arguments:
//-times: number of times that the chord sequence is played
//-up: should the chords be played an octave up?
//-id: the index of the melody that will be played
fun void playMain(int times, int up, int id){
    //set volume for chord
    setVolume(chord, 0.035);
    
    for(0=> int i; i < mainMelody.cap()*times; i++){
        //play beat as quarter notes
        if(i%2){
            playBeat(i/2);
        }
        
        //play chords as eight notes
        playChord(chord, mainMelody[i%mainMelody.cap()] + up, 0);

        //slowly pan during main section
        Math.sin((i+mainMelody.cap()*times*id)*2*Math.PI/36)=>pan.pan;
        
        //play sin melody as eight notes
        //-1 to mute note
        if(melody[id][i%melody[id].cap()] != -1){
            0.2=>sin.gain;
            Std.mtof(scale[melody[id][i%melody[id].cap()]]+12)=>sin.freq;
        }else{
            0=>sin.gain;
        }
        
        eigth=>now;
    }
}

//play outro
//play bass drum and, in last quarter, all the drum elements
//fade out last sin melody note
fun void playOutro(int times){
    //mute chords
    setVolume(chord, 0);
    
    for(0=> int i; i < times; i++){
        //fade out sin note
        0.05*(times-i)=>sin.gain;
        Std.mtof(scale[1]+12)=>sin.freq;
        
        //play bass drum
        0 => beat[0].pos;
        0.3 => beat[0].gain;
        
        //on last quarter, play snare and hihat
        if(i==(times-1)){
            0 => beat[1].pos;
            0.3 => beat[1].gain;
            
            0 => beat[2].pos;
            0.2 => beat[2].gain;
        }
        
        quarter=>now;
    }
}