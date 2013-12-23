// score.ck
<<< "IPMDA Assignment 6 - Cross Song 6: Score" >>>;

//Start schreds
Machine.add(sanitizeDir(me.dir()) + "/drums.ck") => int drumID;
5::second => now;
Machine.add(sanitizeDir(me.dir()) + "/bass.ck") => int bassID;
10::second => now;
Machine.add(sanitizeDir(me.dir()) + "/piano.ck") => int pianoID;
15::second => now;

//Remove shreads
Machine.remove(drumID);
Machine.remove(bassID);
Machine.remove(pianoID);

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