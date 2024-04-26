# Camilladsp-for-pCP9
Files and configuration required to run camilladsp 2 on pCP 9 with auto samplerate switching
This will not work on previous verions of picoreplayer.

This project was heavily influenced by Lykkedk's work on his 'SuperPlayer'
https://github.com/Lykkedk/SuperPlayer-v8.0.0---SamplerateChanger-v1.0.0
This uses the modified alsa plugin coded by scripple
https://github.com/scripple/alsa_cdsp

All files have been packaged up so this install will work the 'tinycore way', without relying on persistence through a static partition.
The alsa plugin has been compiled to work on a 64-bit system. If using a 32-bit version of pCP 9 then you will need to recompile it for your architecture.

# Installation instructions
1) Install modules that will be required
```
tce-load -wi nano git alsa-utils
```
2) Download the repository files

4) Find out the card number for your audio output. These instructions assume you're configuring a simple stereo system. More complex multi-channel cross-over outputs will require more complex configuration.
```
aplay -l
```
Example output:
```
**** List of PLAYBACK Hardware Devices ****
card 0: Headphones [bcm2835 Headphones], device 0: bcm2835 Headphones [bcm2835 Headphones]
  Subdevices: 8/8
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
  Subdevice #2: subdevice #2
  Subdevice #3: subdevice #3
  Subdevice #4: subdevice #4
  Subdevice #5: subdevice #5
  Subdevice #6: subdevice #6
  Subdevice #7: subdevice #7
card 1: AmplifierAK4493 [AP90 Amplifier(AK4493)], device 0: USB Audio [USB Audio]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
```
In this case the desired audio output is card 1, subdevice 0.
3) Edit asound.conf 
