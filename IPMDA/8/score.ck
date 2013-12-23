// score.ck
<<< "IPMDA Assignment 8 - Cross Song 8: Score" >>>;

//set 160 beats per minute
BPM tempo;
tempo.tempo(160.0);

//Initialize MasterPan for global volume control
MasterPan.init();
0.0 => MasterPan.pan.gain;

int drumID;
int drum2ID;
int bassID;
int pianoID;
int melody1ID;
int melody2ID;


//Start schreds

//fade in the drums and bass
MasterPan.fadeIn(5);
Machine.add(sanitizeDir(me.dir()) + "/drums.ck") => drumID;
Machine.add(sanitizeDir(me.dir()) + "/bass.ck") => bassID;
12::second => now;
Machine.remove(bassID);

//break only with drums
12*BPM.quarterNote => now;
Machine.remove(drumID);

//drum fill
Machine.add(sanitizeDir(me.dir()) + "/drums2.ck") => drum2ID;
4*BPM.quarterNote => now;
Machine.remove(drum2ID);

//normal drum pattern is back with bass and rhodes piano
Machine.add(sanitizeDir(me.dir()) + "/drums.ck") => drumID;
Machine.add(sanitizeDir(me.dir()) + "/bass.ck") => bassID;
Machine.add(sanitizeDir(me.dir()) + "/piano.ck") => pianoID;
12::second => now;

//melody starts
Machine.add(sanitizeDir(me.dir()) + "/melody1.ck") => melody1ID;
12::second => now;
Machine.remove(pianoID);
Machine.remove(melody1ID);
Machine.remove(bassID);

//second melody begins
Machine.add(sanitizeDir(me.dir()) + "/melody2.ck") => melody2ID;
6::second => now;

//bass restart shortly after that
Machine.add(sanitizeDir(me.dir()) + "/bass.ck") => bassID;
7::second => now;

//fade out
MasterPan.fadeOut(5);
5::second => now;

//Remove shreads
Machine.remove(drumID);
Machine.remove(melody2ID);
Machine.remove(bassID);

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

