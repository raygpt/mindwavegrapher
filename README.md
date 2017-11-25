# Processing-Based Brainwave Grapher
a brainwave visualizer for the mindwave neurosky eeg headset 

note: parser in progress, program logic incomplete

This is a simple Processing application for graphing changes in brain waves over time. It's designed to read data from a MindWave EEG headset connected via USB.

It's mostly a proof of concept, demonstrating how to parse packets over a serial USB port, monitor signal strength, etc.
Based on a project by [Erik Mika](https://github.com/kitschpatrol) but with a newly-implemented packet parser that does not utilize the Arduino Brain Library. 

BrainGrapher.pde is the main project file. Open this in the Processing PDE to work with the project.

You may need to modfiy the index value in the line serial = new Serial(this, Serial.list()[0], 9600); inside the app's setup() function file depending on which serial / USB port your Arduino is connected to. (Try Serial.list()[1], Serial.list()[2], Serial.list()[3], etc.)

SAFETY: The risks are small, but to be on the safe side you should only plug the Arduino + MindWave combo into a laptop running on batteries alone.


Dependencies

The core Processing project. Tested with Processing 3.0.2.

Version 2.2.5 of the ControlP5 GUI Library is included with this project in the /code folder. No installation is necessary.

Contact

Rama Nakib
ramalnkb@gmail.com
https://github.com/rmnkbofficial
