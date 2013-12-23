// initialize.ck
<<< "IPMDA Assignment 6 - Cross Song 6" >>>;

// Add score file
Machine.add(sanitizeDir(me.dir()) + "/score.ck");

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