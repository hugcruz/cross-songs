// initialize.ck
<<< "IPMDA Assignment 8 - Cross Song 8" >>>;

/* ******* */
/* Classes */
/* ******* */
//BPM to set the tempo
Machine.add(sanitizeDir(me.dir()) + "/BPM.ck");
//MasterPan to set the volume
Machine.add(sanitizeDir(me.dir()) + "/MasterPan.ck");
//DrumMachine contains the common code to play the drums
Machine.add(sanitizeDir(me.dir()) + "/DrumMachine.ck");
//MelodyPlayer contains the common code to play a melody in an Osc
Machine.add(sanitizeDir(me.dir()) + "/MelodyPlayer.ck");


// Add score file
Machine.add(sanitizeDir(me.dir()) + "/score.ck");

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