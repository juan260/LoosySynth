# LoosySynth
A very simple synth built on Chuck language, designed to be controlled from an external source through OSC.
It has functionality to store user created scales and chords, which will sound through as melody and one constant chord. 
The controls for the melody are very nonstandard, 
but could turn out very usefull in a bunch of situations, especially in the context of new technologies.

## Basic functionality
### Melody
The melody works from the idea of displacement from a standard origin of coordinates point. In that sense, for example, it's simillar to an OSC controlled theremin, that recieves two values: 

* The Y axis displacement from the origin and the X axis displacement. The Y axis controlls the cutoff frequency of a low-pass filter, meaning that the value of the Y axis should be in Hertz, ranging from 0 to 20k (approximately) for a full range of timbres, from dark to straight sawtooth. 

* The X axis displacement controlls the displacement from the root note inside the scale. For example, if we are in a D major scale, 0 displacement would mean
 the note D, displacement 1 would correspond to E, 2 to F#, and the same applies for negative numbers. The non-integer displacement values will have an
 intermediate value that makes "musical sense", meaning that there is a continuous function that connects all of the notes, that visually looks like many
 S curves in steps, instead of the discreet steps offered by a piano.

Additionally, the scale can be changed in real time with another set of commands.

### Chords
On top (or bottom) of that, a chord sound is generated. The chords can contain any (reasonable) number of voices, and can also be changed in real time. The chords also go through a low-pass filter before sounding, and there is another parameter similar to the Y axis displacement of the melody controlling this.

### Scales and chords
The user can specify the scales and chords in a specific fashion detailed below. The notes don't need to be stadardly tuned techincally, opening way
for microtonal experimentation. 