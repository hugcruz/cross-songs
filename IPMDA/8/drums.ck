// drums.ck
<<< "IPMDA Assignment 8 - Cross Song 8: Drums" >>>;

Pan2 pan => MasterPan.pan;
//drum pattern
[1, 1, 2, -1] @=> int sequence[];

//Play using DrumMachine class
DrumMachine drumMachine;
drumMachine.init(sequence, pan);
drumMachine.play(BPM.quarterNote);