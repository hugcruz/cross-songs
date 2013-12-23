// initialize.ck
<<< "IPMDA Assignment 7 - Cross Song 7" >>>;

//Add the two classes:
//BPM to set the tempo
Machine.add(sanitizeDir(me.dir()) + "/BPM.ck");
//MasterPan to set the volume
Machine.add(sanitizeDir(me.dir()) + "/MasterPan.ck");

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