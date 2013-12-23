// melody1.ck
<<< "IPMDA Assignment 8 - Cross Song 8: Melody 1" >>>;

//notes to be played
[2,2,2,2,
 5,6,6,6,
 4,4,4,4,
 5,7,7,7,
 0,0,0,0,
 3,4,4,4,
 5,5,5,5,
 6,7,7,7
 ] @=> int melody[];

MelodyPlayer melodyPlayer;
melodyPlayer.init(melody, MasterPan.pan);
melodyPlayer.play(BPM.quarterNote);