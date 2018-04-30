# bashRadio
### David Cote | MIT License 2018
### This is a internet radio in Bash script 4 designed for the Raspberry Pi running on Raspbian.
The intent behind this project was to familiarize myself with Linux and Bash scripting.
I didn't want to use Python or other programming languages.

It uses Alsamixer for the volume and cvlc (VLC) to play the medias. 
You will need the timer.sh script to add a timer to shut down the radio.
This is not a final product by no means but it works. I use it everyday.
I got a ground loop isolator and plugged speakers to the pi to remove interferences.

### The next step might be a webscraper in Python that finds all the available radios online.

## Known bugs
The code to play local files doesn't catch the right PID process. I suspect it's because I use the 'find' command.
There's no error catching. So if the radio stream is dead it won't tell you. It just won't start.
The volume control option only open Alsamixer which causes the radio script to exit. The volume up and down are working fine.
Not a bug, but I eventually want to refactor the code to replace the 'if then else' by a 'case' or with a function that uses a dictionary.
