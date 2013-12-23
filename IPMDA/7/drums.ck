// drums.ck
<<< "IPMDA Assignment 7 - Cross Song 7: Drums" >>>;

/* ******************************** */
/* SOUND CHAIN, NOTES AND DURATIONS */
/* ******************************** */

//Drums with reverberation filter
Pan2 pan => JCRev rev => MasterPan.pan;
SndBuf beat[3];
string files[];

0.5=>rev.mix;

//drum pattern
[0, 1, 0, 2,
 0, 1, 0, 2,
 0, 1, 0, 2,
 0, 1, 0, 0] @=> int snare[];

/* ************ */
/* MAIN SECTION */
/* ************ */

init();
initBeat(beat);

0 => int i;

while(true){
    //play sample
    Math.random2f(0.1,0.2) => beat[snare[i%snare.cap()]].gain;
    0 => beat[snare[i%snare.cap()]].pos;
    
    //advance time
    BPM.eighthNote => now;

    //reduce filter effect through time
    if(rev.mix()>0){
        rev.mix() - 0.025 => rev.mix;
    }
    
    //increment index
    1+=>i;
}

/* ********* */
/* FUNCTIONS */
/* ********* */
//sanitize directory: woraround bug in some versions of Chuck
fun string sanitizeDir(string dir){
    if (dir.substring(1,1) == ":"){
        dir.replace(1,1,"\\:");
    }
    return dir;
}

//initialize pan and sample files
fun void init(){
    -0.3=>pan.pan;

    me.dir(-1) => string path;
    [
        path + "/audio/hihat_01.wav",
        path + "/audio/kick_01.wav",
        path + "/audio/snare_01.wav"
    ] @=> files;
}

// initialize SndBuf array for beat
fun void initBeat(SndBuf buffer[]){
    for(0=> int i; i< buffer.cap(); i++){
        files[i] => buffer[i].read;
        buffer[i] => pan;
        0=> buffer[i].gain;
    }
}