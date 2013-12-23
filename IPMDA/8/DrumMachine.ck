// DrumMachine.ck

//Contains the common code to play the drums
public class DrumMachine {
    SndBuf beat[3];
    string files[];
    int sequence[];
 
    //initialize the class with target Pan2 and the array with the drum sequence
    fun void init(int drumSequence[], Pan2 pan){
        drumSequence @=> sequence;
        initClass(pan);
        initBeat(beat, pan);
    }
    
    //play the drums in an infinite loop with the specified tempo
    fun void play(dur duration){
        0 => int i;

        while(true){
            //play samples
            0.025 => beat[0].gain;
            0 => beat[0].pos;
            
            sequence[i%sequence.cap()] => int drumIndex;
            if(drumIndex != -1){
                0.1 => beat[drumIndex].gain;
                0 => beat[drumIndex].pos;
            }
            
            //advance time
            duration => now;
            
            //increment index
            1+=>i;
        }
    }

    //initialize pan and sample files
    fun void initClass(Pan2 pan){
        -0.3=>pan.pan;

        me.dir(-1) => string path;
        [
            path + "/audio/hihat_02.wav",
            path + "/audio/kick_01.wav",
            path + "/audio/snare_01.wav"
        ] @=> files;
    }

    // initialize SndBuf array for beat
    fun void initBeat(SndBuf buffer[], Pan2 pan){
        for(0=> int i; i< buffer.cap(); i++){
            files[i] => buffer[i].read;
            buffer[i] => pan;
            0=> buffer[i].gain;
        }
    }
}