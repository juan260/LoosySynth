//    File: LoosySynth.ck
//    Author: Juan Riera Gomez
    
//    This file contains the object LoosySynth
//    which is a Singleton that recieves packages, and
//    does the appropiate actions with the contents.



///////////////////////////////////////////////////////////////////////////
//    Auxiliar function to extract an undetermined number of floats from an OSC
//    message. It has been designed for the initialization messages of the chords and 
//    scales , in which we are not sure how many notes will come.

fun float[] extractFloatsFromOscMsg(OscMsg msg){
      float noteSet[msg.typetag.length()-3]; 
      for(3 => int i; i<msg.typetag.length(); i++){
          if(msg.typetag.charAt(i) == 'f'){
                  msg.getFloat(i) => noteSet[i-3];
          } 
      }
      return noteSet;
  }
  
  
//MACROS
0 => int DISPLACEMENTMSG;
1 => int CONTROLMSG;
2 => int INITMSG;
0 => int SCALECHANGE;
1 => int CHORDCHANGE;
0 => int NEWSCALE;
1 => int NEWCHORD;
999 => int DEFAULTPORT;
  
class LoosySynth{
    OscMsg msg; // OSC Message
    OscIn oin; // OSC client to recieve messages
    
    // Conection of the signal chain
    JCRev masterReverb;
    Delay masterDelay;
    Gain masterGain; 
    Gain delayFeedback;
    Dyno compressor;
    Dyno limiter;
    // On top of the delay we add a direct signal
    
    LPF melodyFilter => masterReverb;
    
    //SawOsc melodyOscillator => melodyFilter;
    //Flute melodyOscillator => melodyFilter;
    Moog melodyOscillator => melodyFilter;
    0 => melodyOscillator.filterQ;
    0.03 => melodyOscillator.lfoDepth;
    4 => melodyOscillator.lfoSpeed;
    1 => melodyOscillator.volume;
    1 => melodyOscillator.noteOn;
    440 => melodyOscillator.freq;
    

        masterReverb => masterDelay => masterGain;
        masterReverb => masterGain => compressor => limiter;
        5 => masterGain.gain; // Turn down the volumes
        //0.2 => melodyOscillator.gain;
        //0.5 => masterReverb.gain; 
        0.6 => masterDelay.gain;
        
        compressor.compress();
        limiter.limit();
        
        // We adjust the necessary parameters
        .5 => masterReverb.mix;
        .6::second => masterDelay.max => masterDelay.delay; 
        // Delay feedback
        masterDelay => delayFeedback => masterDelay;
        0.4 => delayFeedback.gain;
    
    // Creacion necessary handlers
    ScaleHandler scaleHandler;
    ChordOscHandler chordOscHandler;
    
    chordOscHandler.connect(masterReverb);
    
    // Assign Middle C to the oscillator, even though it will start in silence
    Std.mtof(60) => melodyOscillator.freq;
  

//    Function to handle the messages
//    Input: OSC message

    fun void handleMessage(OscMsg msg){
        if(msg.typetag.charAt(0) == 'i'){
                  if(msg.getInt(0) == DISPLACEMENTMSG && msg.typetag == "iififff"){
                      // Note message
                      if (msg.getInt(1)) {
                          // Adjust gain and cutoff Freq
                          chordOscHandler.setFilterCutoff(
                          Math.exp(msg.getFloat(2)));
                          chordOscHandler.setGain(1);
                          
                      }
                      
                      if (scaleHandler.inSilence()){
                          // Invalid or silent scale
                          0.0 => melodyOscillator.volume;
                          
                      } else if(msg.getInt(3)) {
                          // Adjust the note, the gain and the filter of the melody
                          msg.getFloat(4) => melodyOscillator.volume;
                          scaleHandler.getRoundedFreqFromMidi(
                          msg.getFloat(5)+60)  => 
                          melodyOscillator.freq;
                          
                          Math.exp(msg.getFloat(6)) => melodyFilter.freq;
                          //(msg.getFloat(6)) => melodyFilter.freq;
                        
                          
                          
                            
                      }
                      
                  }
                  // Control message
                  else if(msg.getInt(0) == CONTROLMSG){
                    if(msg.typetag == "iiss"){
                      if(msg.getInt(1) == SCALECHANGE){
                          
                          //Change scale
                          scaleHandler.changeNoteSet(msg.getString(2),
                          msg.getString(3));
                      } else if(msg.getInt(1) == CHORDCHANGE){
                          //Change chord
                          chordOscHandler.changeChord(msg.getString(2),msg.getString(3));
                      }
                    }
                  }
                  // Initialization message
               else if(msg.getInt(0)==INITMSG && msg.typetag.charAt(1)=='i' && msg.typetag.charAt(2)=='s'){
                     
                   // Scale initialization
                    if (msg.getInt(1) == NEWSCALE){
                              extractFloatsFromOscMsg(msg) @=> float extractedFloats[];
                              scaleHandler.addSetToTableFromMidi(msg.getString(2), extractedFloats);
                              


                  } else if(msg.getInt(1) == NEWCHORD) {
                      // Chord initialization
                      extractFloatsFromOscMsg(msg) @=> float extractedFloats[];
                      chordOscHandler.addChordToTable(extractedFloats, msg.getString(2));
                  }
              }
                  
            
           
       }
    }
       
//       Funto start the synth.
//       Ins: the port from where to expect the messages.      

    fun void start(int port){
           
        port => oin.port;
        oin.listenAll();
        
        limiter=>dac;
        //masterGain => dac;
        //melodyOscillator.noteOn(100);
        
        while(true)
        {   
            oin =>now;
            while(oin.recv(msg))
            { 
              handleMessage(msg);
            }
            //0.005::second +=> now;

                
        }
    }
}
// Start of the synth
LoosySynth s;
s.start(DEFAULTPORT);
