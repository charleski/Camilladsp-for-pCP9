# Camilladsp-for-pCP9
Files and configuration required to run camilladsp 2 on pCP 9 with auto samplerate switching and integration of the SR switcher with the camilladsp GUI.
This will not work on previous verions of picoreplayer.

This project was heavily influenced by Lykkedk's work on his 'SuperPlayer'
https://github.com/Lykkedk/SuperPlayer-v8.0.0---SamplerateChanger-v1.0.0  
This project uses the modified alsa plugin coded by scripple  
https://github.com/scripple/alsa_cdsp

I've opened a support thread for this project over at DIYAudio:  
https://www.diyaudio.com/community/threads/camilladsp-2-for-picoreplayer-9.412118

All files have been packaged up so this install will work the 'tinycore way', without relying on persistence through a static partition. 
The alsa plugin has been compiled to work on a 64-bit system. If using a 32-bit version of pCP 9 then you will need to recompile it for your architecture.

You will need to connect to your Pi through SSH to enter these commands, as described in the pCP docs:
https://docs.picoreplayer.org/how-to/access_pcp_via_ssh/
Once you have SSH access, simply copy and paste the commands below line-by-line into the terminal. The only step that may require more user input is step 4, where you need to set the right output for the DAC attached to your Pi.

# Installation instructions
**1)** Install modules that will be required
```
tce-load -wi nano git python3.11
```

**2)** Download the repository files
```
git clone https://github.com/charleski/Camilladsp-for-pCP9.git
cd Camilladsp-for-pCP9
```

**3)** Install the extensions using the script provided.
```
chmod a+x *.sh
./install_camilla.sh
```

**4)** Find out the card name for your audio output. These instructions assume you're configuring a simple stereo system. More complex multi-channel cross-over outputs will require more complex configuration.

The audio output card can be specified by using either its number or its name. Unfortunately, it's possible for a card's number to vary between reboots, especially on a fresh system (the reasons for this are buried in the fine details of Alsa). So the bullet-proof way to point to a card is by using its name, and this is the method described here.
These instructions are based on using a DAC connected via USB, but should also be applicable to audio hats.

To find your card's name, enter
```
aplay -L | grep :CARD
```
Which will produce an output like this:
```
hw:CARD=Headphones,DEV=0
plughw:CARD=Headphones,DEV=0
default:CARD=Headphones
sysdefault:CARD=Headphones
dmix:CARD=Headphones,DEV=0
hw:CARD=AmplifierAK4493,DEV=0
plughw:CARD=AmplifierAK4493,DEV=0
default:CARD=AmplifierAK4493
sysdefault:CARD=AmplifierAK4493
front:CARD=AmplifierAK4493,DEV=0
surround21:CARD=AmplifierAK4493,DEV=0
surround40:CARD=AmplifierAK4493,DEV=0
surround41:CARD=AmplifierAK4493,DEV=0
surround50:CARD=AmplifierAK4493,DEV=0
surround51:CARD=AmplifierAK4493,DEV=0
surround71:CARD=AmplifierAK4493,DEV=0
iec958:CARD=AmplifierAK4493,DEV=0
dmix:CARD=AmplifierAK4493,DEV=0
```
The card name is the text between 'CARD=' and the first comma. So in this case the desired card name is AmplifierAK4493.

Edit asound.conf to point to the desired audio output. An example asound.conf is provided to serve as a template.
```
nano asound.conf
```
Here is the asound.conf provided:
```
#    --- sound_out is the real hardware card ---
pcm.sound_out {
type hw
card 1  <-- change to the name of your card
device 0  <-- change to the subdevice if needed
}

ctl.sound_out {
type hw
card 1  <-- change to the name of your card
}

#   --- CamillaDSP with Seashell's alsa-plugin ---
# Howto here : https://github.com/scripple/alsa_cdsp
pcm.camilladsp {
    type cdsp
      cpath "/usr/local/bin/camilladsp"
      config_in "/home/tc/camilladsp/configs/alsa_cdsp_template.yml"
      config_out "/home/tc/camilladsp/configs/camilladsp.yml"
      cargs [
        -o "/home/tc/camilladsp/camilladsp.log"
        -l error
        -p "1234"
        -s "/home/tc/camilladsp/statefile.yml"
      ]
      channels 2
      rates = [
        44100
        48000
        88200
        96000
        176400
        192000
        352800
        384000
      ]
      extra_samples 0
}
```
This is changed to
```
#    --- sound_out is the real hardware card ---
pcm.sound_out {
type hw
card AmplifierAK4493
device 0
}

ctl.sound_out {
type hw
card AmplifierAK4493
}

#   --- CamillaDSP with Seashell's alsa-plugin ---
# Howto here : https://github.com/scripple/alsa_cdsp
pcm.camilladsp {
    type cdsp
      cpath "/usr/local/bin/camilladsp"
      config_in "/home/tc/camilladsp/configs/alsa_cdsp_template.yml"
      config_out "/home/tc/camilladsp/configs/camilladsp.yml"
      cargs [
        -o "/home/tc/camilladsp/camilladsp.log"
        -l error
        -p "1234"
        -s "/home/tc/camilladsp/statefile.yml"
      ]
      channels 2
      rates = [
        44100
        48000
        88200
        96000
        176400
        192000
        352800
        384000
      ]
      extra_samples 0
}
```

**5)** Change bootlocal.sh to get camillagui running during startup. 
A sample bootlocal.sh is provided as a template. If you don't require any other commands to be run at boot then you can just copy this over the default. If you do need other commands these can be tacked on at the end using nano. 
**Warning** If you are running pCP *only* as a squeezelite player (i.e. LMS isn't installed and run on boot) then the standard pcp startup script will get confused by the virtual alsa device we are using and will fail to start squeezelite on boot. You can fix this by adding the line
```
pcp slr
```
to the end of bootlocal.sh.

**6)** Install the boot files using the script provided. This will also make backups in your home directory. Don't simply try to copy the files, as they won't have the correct permissions.
```
sudo ./install_boot.sh
```

**7)** Delete the install directory, then backup and reboot
```
cd /home/tc
rm -rf Camilladsp-for-pCP9
sudo pcp br
```

**8)** Tell squeezelite to send its audio to camilladsp. You can change this in the Squeezelite Settings tab of the pCP web interface:

![SetupSqueezelite](https://github.com/charleski/Camilladsp-for-pCP9/assets/4446874/bc8305cf-5363-418b-8461-82d46b98cc10)

**9)** After squeezelite automatically restarts you can check that camilladsp is working by opening the gui interface at http://pcp.local:5005 or http://[ip address of your raspberry pi]:5005 . You should see this on the left side:  
![CamOK](https://github.com/charleski/Camilladsp-for-pCP9/assets/4446874/19b09476-c225-49a6-bd33-29acd2ba737b)


# Usage
The camilladsp web interface can now be accessed through a browser at  
http://pcp.local:5005  
or  
http://[ip address of your raspberry pi]:5005

If you already have camilladsp config files that you want to use, then place them in /home/tc/camilladsp/configs.
Note that the config files need to follow the following rules:  
a) The devices: capture: section **must** have the following structure:
```

devices:
  ...
  capture:
    ...
    filename: /dev/stdin
    format: ...
    ...
    type: File
...
```
I.e. the input type must be set to File with a filename /dev/stdin and the capture format line must come immediately after the filename. This ordering is true by default when creating a new config in the gui and so you shouldn't need to worry about it. In almost all cases your capture format will be S32LE, but as scripple's plugin allows this to be varied I've retained that functionality in case anyone needs it.  
b) The devices: playback: section needs to route output to the Alsa device sound_out:
```
devices:
  ...
  playback:
    ...
    device: sound_out
    ...
    type: Alsa
...
```
For almost all modern high quality DACs the output format should be S32LE, but yoou can change this if needed.

You can now change the active config in the gui by going to the Files tab and clicking on the star icon next to your desired config:
![Camillagui](https://github.com/charleski/Camilladsp-for-pCP9/assets/4446874/c7c2741c-a8cb-4f2f-8748-a1fff383519e)
As shown, you will see two extra configs in the directory: camilladsp.yml and alsa_cdsp_template.yml. Leave these alone, as they are generated automatically and are used to facilitate the automatic samplerate switching.

You can edit your config in the gui (e.g. change filter values etc.). After performing the edits go the the Files tab and save the config out to a file - either to a new file or by clicking the floppy disk icon next to the star for an existing config. Then click on the star icon to set it active. By setting a config to be active you are also updating the template used for the samplerate switcher. If you simply click the 'Apply to DSP' or 'Apply to DSP and Save' buttons then the template won't be updated and your edits will be lost if the input rate changes and the alsa plugin regenerates the config to use.
If you want your edits to persist after a reboot then don't forget to do a backup of pCP before rebooting or shutting down, either through the Backup button on the main pCP page or by pcp bu through SSH.

You will find a directory named camillagui_config in /home/tc/camilladsp. This contains camillagui.yml and gui_config.yml, which may be edited to alter the behaviour of the gui as described in the camillagui docs. The only caveat is that the line on_set_active_config: in camillagui.yml must point to a command that will call /opt/camillagui/processTemplate.sh [path to active config], though you can alter it to include other commands as well.

# Note on updates
After performing an insitu update of pCP the bootlocal.sh file will need to be altered, since the pCPstart section is reset to the default version. 
The lines
```
#pCPstart------
/usr/local/etc/init.d/pcp_startup.sh 2>&1 | tee -a /var/log/pcp_boot.log
#pCPstop------
```
need to be changed to 
```
#pCPstart------
/usr/local/etc/init.d/pcp_startup.sh >> /var/log/pcp_boot.log 2>&1
#pCPstop------
```
This can be done manually with
```
sudo nano /opt/bootlocal.sh
```
This is because bootlocal.sh gets hung up on the tee command even after the pcp_startup.sh script finishes. 
