// MelodyPlayer.ck

//Contains the common code to play an Osc melody
public class MelodyPlayer{
    [48, 50, 52, 53, 55, 57, 59, 60] @=> int scale[];
    int melody[];
    TriOsc osc;
    
    //initialize the class with target Pan2 and the array with the sequence of notes
    fun void init(int melodySequence[], Pan2 pan){
        osc => pan;
        melodySequence @=> melody;
        initClass();
    }

    //play the notes in an infinite loop with the specified tempo
    fun void play(dur duration){
        0=>int i;
        while(true){
            //select note to play
            melody[i%melody.cap()] => int note;
            playNote(note);
            
            duration => now;
            
            //increment index
            1+=>i;
        }
    }
    
    //initialize Osc
    fun void initClass() {
        0.05 => osc.gain;    
    }

    //Play note in Osc
    fun void playNote(int note) {
        if(note!=-1){
            Std.mtof(scale[note]+12) => osc.freq;
        } else {
            0 => osc.freq;
        }
    }
}