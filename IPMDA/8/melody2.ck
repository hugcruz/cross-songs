// melody2.ck
<<< "IPMDA Assignment 8 - Cross Song 8: Melody 2" >>>;

//notes to be played
[4,4,4,4,
 3,3,3,3,
 2,2,2,2,
 1,1,1,1,
 0,1,2,3,
 1,2,3,4,
 2,3,4,5,
 3,4,5,7
 ] @=> int melody[];

MelodyPlayer melodyPlayer;
melodyPlayer.init(melody, MasterPan.pan);
melodyPlayer.play(BPM.quarterNote);