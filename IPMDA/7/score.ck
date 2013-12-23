// score.ck
<<< "IPMDA Assignment 7 - Cross Song 7: Score" >>>;

//set 96 beats per minute -> quarter note will be 0.625 seconds
BPM tempo;
tempo.tempo(96.0);

//Initialize MasterPan for global volume control
MasterPan.init();
0.0 => MasterPan.pan.gain;


//Start schreds

//fade in the drums
MasterPan.fadeIn(5);
Machine.add(sanitizeDir(me.dir()) + "/drums.ck") => int drumID;
5::second => now;

//add bass and piano
Machine.add(sanitizeDir(me.dir()) + "/bass.ck") => int bassID;
Machine.add(sanitizeDir(me.dir()) + "/piano.ck") => int pianoID;
20::second => now;

//fade out
MasterPan.fadeOut(5);
5::second => now;

//Remove shreads
Machine.remove(drumID);
Machine.remove(bassID);
Machine.remove(pianoID);

/* ********* */
/* FUNCTIONS */
/* ********* */
//sanitize directory: workaround bug in some versions of Chuck
fun string sanitizeDir(string dir){
    if (dir.substring(1,1) == ":"){
        dir.replace(1,1,"\\:");
    }
    return dir;
}

