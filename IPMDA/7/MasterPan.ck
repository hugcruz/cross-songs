//MasterPan.ck

//Class that contains a global static pan
//to set the volume to all instruments
//Has functionality to fade in and out in a separate shread

public class MasterPan
{
    // global pan value
    static Pan2 @pan;
    
    //initializes the MasterPan object (only needed once)
    fun static void init(){
        new Pan2 @=> pan;
        pan => dac;
    }
    
    //fades in from 0 to 1 in the number of seconds required
    fun static void fadeIn(int seconds){
        spork~fade(0.0, seconds, 1);
    }

    //fades out from 1 to 0 in the number of seconds required
    fun static void fadeOut(int seconds){
        spork~fade(1.0, seconds, -1);
    }
    
    //fades in and out
    //should be used in separate shread
    fun static void fade(float volume, int seconds, float step){
        now => time begin;
        //loop in the required number of seconds
        while(now - begin < seconds::second){
            //adapt volume in equal step divided by the number of seconds
            step * 1/(seconds/0.01) +=> volume;
            volume => pan.gain;
            //usually finer granularity than the music
            0.01::second => now;
        }
    }
}

