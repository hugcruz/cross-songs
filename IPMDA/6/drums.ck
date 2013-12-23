// drums.ck
<<< "IPMDA Assignment 6 - Cross Song 6: Drums" >>>;

/* ******************************** */
/* SOUND CHAIN, NOTES AND DURATIONS */
/* ******************************** */

Pan2 pan => dac;
SndBuf beat[2];
string files[];

0.625::second => dur quarter;
quarter/2 => dur eighth;
eighth/2 => dur sixteenth;

[-1, 1, 1] @=> int snare[];

now => time startTime;

/* ************ */
/* MAIN SECTION */
/* ************ */

init();
initBeat(beat);

0 => int i;
1 => float localGain;

while(true){
    //-1 -> play hihat 4 (open)
    // 1 -> play hihat 1 (closed)
    if(snare[i%snare.cap()] != -1){
        Math.random2f(0.1,0.2)*localGain => beat[1].gain;
        0 => beat[1].pos;
    } else{
        Math.random2f(0.1,0.2)*localGain => beat[0].gain;
        0 => beat[0].pos;
    }
    
    //fadeout after 20 seconds
    if((now - startTime)/second > 20.0){
        0.1-=>localGain;
    }
    //stop playing after 25 seconds
    if((now - startTime)/second > 25.0){
        0.0=>localGain;
    }
    
    //give some swing to the loop, setting different durations
    //each loop will last 2 quarters: 1.25 seconds
    if((i%snare.cap()) == 0){
        quarter => now;
    }
    if((i%snare.cap()) == 1){
        sixteenth*3 => now;
    }
    if((i%snare.cap()) == 2){
        sixteenth => now;
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
        path + "/audio/hihat_04.wav",
        path + "/audio/hihat_01.wav"
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