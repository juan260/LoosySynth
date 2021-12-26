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

## Project context

This project is an adaptation of one previous project of mine called Loosy. Loosy practically uses LoosySynth, but with some editing to make it fit perfectly.
Loosy additionally has another module developed in Unreal Engine, called LoosyController, that controlls the synth from a pair of Hololens 2 glasses. For more info, [here](https://github.com/juan260/Loosy)'s the repository. In the resulting project, the user could play a melody controlling its volume, timbre, scale and note in real time with the right hand, and play chords with the left hand.

## OSC Message structure
LoosySynth is constantly listening to messages, and it is ready to recieve a more or less constant flow of them. There are three types of messages, and all of them store everything in the contents of the package (we don't use the address). The port by default (can be changed in the code) is 9999.

#### Displacement messages
These messages used to control the melody recieve the X and Y axis displacements we were talking about before, along with some other parameters:

| Name | Type | Description|
|:-------:|:------:|:-----------------:|
|Message type| Int | Should be 0.|
|Chords Silence| Int |0 if the chords should be silent.|
|Chords cutoff| Float | Cutoff frquency for the low pass filter of the chords.|
|Melody Silence| Int | 0 if the melody should remain silent.|
|Melody gain| Float | Gain (typically 0-1) for the melody.|
|Melody displacement| Float | Controls the note of the scale, 0 would be the root, 1 the second note, -1 the previous to the root etc.|
|Melody cutoff| Float | Cutoff frequency of the low pass filter applied to the melody.|

#### Control messages
These messages are used to change the chord that is sounding and the scale of the melody.
| Name | Type | Description|
|:-------:|:------:|:-----------------:|
|Message type| Int | Should be 1.|
|Scale or chord change| Int | Should be 0 for scale change and 1 for chord change.|
|Root| String |Root of the new chord or scale (e.g. "C", "B", "Bb", "F#", "Gbb" "A#####").|
|Quality| String| Quality (name) of the chord or scale (e.g. "Major", "Minor", "Minor7").|

#### Initialization messages

These messages are used to set up scales and chords. The user can create any scale or chord in standard tuning or not.
| Name | Type | Description|
|:-------:|:------:|:-----------------:|
|Message type| Int | Should be 2. |
|Scale or chord| Int| 0 for new scale and 1 for new chord.|
|Name| String| Name of the chord or scale quality.|
|Notes| Arbitrary amount of Floats |Notes that compose the string or chord expressed in midi notation.|

The multiple field "Notes" can express the chord or scale **starting** on an arbitrary root. Don't be scared by the "midi notation", it just means that every whole number up means a half step up in western standard tempered tuning (the piano tuning). In the case of the scales, a whole repetition of the scale should appear including the first note of the next repetition. This meansd that for scales that repeat every octave, the root should appear first and last.

### Message use example
After starting LoosySynth we send the following messages:
* Create Major scale:

|Type| Int|Int|String| Float|Float|Float|Float|Float|Float|Float|Float|
|----|----|---|------|------|------|----|-----|-----|-----|-----|-----|
|Value|2|0| "Major"|60|62|64|65|67|69|71|72|

* Create Minor scale:

|Type| Int|Int|String| Float|Float|Float|Float|Float|Float|Float|Float|
|----|----|---|------|------|------|----|-----|-----|-----|-----|-----|
|Value|2|0| "Minor"|60|62|63|65|67|68|70|72|

* Create Chromatic scale:

|Type| Int|Int|String| Float|Float|
|Value|2|0| "Chromatic"|60|61|

* Create Diminished scale:

|Type| Int|Int|String| Float|Float|Float|
|Value|2|0| "Chromatic"|60|61|63|

* Create Major chord:

|Type| Int|Int|String| Float|Float|Float|
|Value|2|1| "Major"|60|64|67|

* Create Minor chord:

|Type| Int|Int|String| Float|Float|Float|
|Value|2|1| "Minor"|60|63|67|






To be continued...
