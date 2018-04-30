#!/bin/bash
# David Cote | MIT License | 2018
## More radio station at https://www.radionomy.com/en/style
## Optimize this script with functions
## https://www.shellscript.sh/functions.html
## To fix the scopes of variables
## https://www.linuxjournal.com/content/return-values-bash-functions
## To learn more about hash tables in Bash
## https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash
## To format Bash output
## https://linuxconfig.org/bash-printf-syntax-basics-with-examples
###################TestZone#############################################
# With this snippet 
# Add a hard coded bash Array list to a text file
#declare -A animals
#animals=( ["moo"]="cow" ["woof"]="dog")
#echo ${!animals[@]} >> animals.txt
#for sound in "${!animals[@]}"; do echo "$sound - ${animals[$sound]}"; done
#echo "${animals[moo]}"

RADIOLIST=radioList.txt
#echo First column of a text file
#echo `grep -Eo '^[^ ]+'favRadio.txt`

# To remove last line
#`sed -i "1d" favRadio.txt` 

# To show only one line
#echo Sed will show the 6th line only
#sed -n 6p favRadio.txt

# To show the first item of the 6th line
#sed -n 6p favRadio.txt > bozo.tmp
#grep -Eo '^[^ ]+' bozo.tmp > bozo2.tmp
#echo Bozo.tmp which is the 6th lne
#cat bozo.tmp
#echo Bozo2.tmp Which is the first item with grep
#cat bozo2.tmp
#echo Try to print with awk on Bozo.tmp
#awk '{print $1 "\t" $2}' bozo.tmp
#urltest=`awk '{print $2}' bozo.tmp`
#echo "URL is: $urltest"
#rm bozo.tmp
#rm bozo2.tmp
# To only print the name
#cat favRadio.txt | awk '{print $1;}'
# To only print the url
#cat favRadio.txt | awk '{print $2;}'
# To show the entire array
#echo ${anarray[@]} > temp.tmp
#declare -a myarray
#readarray myarray < file_pathname # Include newline.
#readarray -t myarray < file_pathname # Exclude newline.
################################################
kill_radio()
{
    echo "Turning off channel"
    kill `cat save_pid.txt`
    rm save_pid.txt
    rm bozo.tmp
}
list_radios()
{
    awk '{print NR": "$0}' radioList.txt 
    #awk '{print i++ " - " $1 "\t" $2}' radioList.txt
}
find_radiourl()
{
    LINENUMBER=$1
    P2="p"
    varB=$LINENUMBER$P2
    #echo "Finding the URL for line $1"
    # To only print the url
    #sed -n "$LINENUMBER$P2" radioList.txt > bozo.tmp
    sed -n "$varB" radioList.txt > bozo.tmp 
    awk '{print $1 "\t" $2}' bozo.tmp
    RADIONAME=`awk '{print $1}' bozo.tmp`
    urlnow=`awk '{print $2}' bozo.tmp`
    echo $urlnow
}
play_radio()
{
    USERINPUT=$1
    #URL=(find_the_radiourl $USERINPUT)
    nohup cvlc $urlnow > radio.log 2>&1 & 
    echo $! > save_pid.txt
}

add_a_radio()
{
    RADIONAME=$1
    RADIOURL=$2
    RADIODESC=$3
    echo "Adding radio $RADIONAME with url #RADIOURL and with this description $RADIODESC"
    echo $RADIONAME $RADIOURL $RADIODESC >> favRadio.txt
}
# Begin here
# Replace the While loop by while True
i="0"
while [ $i -lt 30 ]; 
do
echo $i
RADIONAME=`awk '{print $1}' bozo.tmp`
urlnow=`awk '{print $2}' bozo.tmp`
echo "######################################################################"
echo "play : Show list of available radios | help : Show help menu"
echo "shortcut : Show Hardcoded shortcuts | f : Show Favorites List"
echo "q : Quit | qr : Quit and kill Radio | fr : Favorite Radio | *fx : Del"
echo "k : Kill radio  | log : Show Radio Log | l: Show Radio List"
echo "v : Volume control with Alsamixer"
echo "a : Volume Up | z : Volume down | mute : Mute the radio"
echo "timer : Set a timer to kill radio e.g. 10m or 30s | tq : Cancel Timer"
echo "Last command: $choice | $RADIONAME playing at $urlnow" 
read -p "What do we do ? : " choice
echo "######################################################################"
if test "$choice" == "play"
then
    list_radios
    #read -n 1
    read -p "Enter the number you want to play : " radioChoice
    kill_radio
    find_radiourl $radioChoice
    play_radio $urlnow

fi
if test "$choice" == "local"
then
    folder=""
    read -p "Enter the folder in /Music/ you want to play : " folder
    kill_radio
    nohup find ./Music/$folder -type f -exec cvlc --one-instance --playlist-enqueue --playlist-autostart -Z '{}' + > radio.log 2>&1 &
    echo $! > save_pid.txt
fi
if test "$choice" == "kill"
then
    kill_radio
fi
if test "$choice" == "shortcut"
then
    echo "###################################################"
    echo "Music Style : shortcut"
    echo "Rock : rock |  Solo Guitar : guit, guit2, guit3"
    echo "Reggae :re, re1, re2, re3"
    echo "Electro : electro | Jazz: jazz1"
    echo "Classical: cl,cl2,cl3(beethoven), cl4, cl5, piano"
    echo "Bachata : latin   | Hindi Bollywood: hindi"
    echo "Ambient : amb1, amb2    | Top 40 : t"
    echo `cat -n favRadio.txt` 
    read -p "Enter the number you want to play : " lineNumber
    varA="p"
    varB=$lineNumber$varA
    sed -n "$varB" favRadio.txt > bozo.tmp 
    awk '{print $1 "\t" $2}' bozo.tmp
    urltest=`awk '{print $2}' bozo.tmp`
    echo "URL is: $urltest"
fi
if test "$choice" == "lr"
then
    grep -Eo '^[^ ]+' favRadio.txt > listRadio.tmp
    cat -n listRadio.tmp
    rm listRadio.tmp
    #echo `cat -n favRadio.txt` 
    #for line in "${!myarray[@]}"; do echo "$line - ${myarray[$line]}"; done
fi

if test "$choice" == "fm"
then
    read -p "Enter a shortcut for the radio ? : " choiceOne
    read -p "Enter the url of the radio ? : " choiceTwo
    #read -p "Enter 1 word to describe the genre ? : " choiceThree
    add_a_radio $choiceOne $choiceTwo #$choiceThree
    echo `cat favRadio.txt` 
fi

if test "$choice" == "fr"
then
    echo "$RADIONAME, $urlnow" >> favRadio.txt
    echo $current " is now in your favorites"
    echo `cat favRadio.txt` 
fi
if test "$choice" == "f"
then
    echo `cat -n favRadio.txt` 
fi
if test "$choice" == "fx"
then
    echo `cat -n favRadio.txt` 
    read -p "Enter the number you want to delete : " lineNumber
    varA="d"
    varB=$lineNumber$varA
    `sed -i "$varB" favRadio.txt` 
    echo `cat -n favRadio.txt` 
fi

if test "$choice" == "log"
then
    echo `cat radio.log` 
    read -p "Do you want to delete it? (y/n): " delLog
    if test "$delLog" == "y"
    then
        rm radio.log
    fi
fi
if test "$choice" == "timer"
then
    echo "Set a timer"
    read -p "Set Duration (e.g. 30m or 5s) : " timerTime
    nohup bash ./timer.sh $timerTime >> radio.log 2>&1 & 
    echo $! > timer.log
    echo "Timer set for $timerTime"
fi
if test "$choice" == "tq"
then
    echo "Cancel timer"
    kill `cat timer.log`
    rm timer.log
fi
if test "$choice" == "q"
then
    echo "See ya!"
    exit
fi
if test "$choice" == "qr"
then
    echo "See ya!"
    kill `cat save_pid.txt`
    rm save_pid.txt
    exit
fi
if test "$choice" == "k"
then
    echo "See ya!"
    kill `cat save_pid.txt`
    rm save_pid.txt
fi
## Hard coded shortcuts for radios
if test "$choice" == "vpr"
then
    nohup cvlc https://vpr.streamguys1.com/vpr64.mp3?ck=1524935314234 > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "guit"
then
    nohup cvlc http://199.115.115.72:2628/stream > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "guit2"
then
    nohup cvlc http://199.115.115.72:2728/stream > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "guit3"
then
    nohup cvlc http://144.217.158.59:5230/stream > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi

if test "$choice" == "rock"
then
    nohup cvlc http://streaming211.radionomy.com:80/LA-GRIETA > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "re"
then
    nohup cvlc https://streaming.radionomy.com/Africa-Time-For-Peace > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "re1"
then
    nohup cvlc http://hd.lagrosseradio.info:8300 > radio.log  2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "re2"
then
    nohup cvlc https://streaming.radionomy.com/Reggae-Connection > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "re3"
then
    nohup cvlc https://streaming.radionomy.com/Ambiance-Reggae > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "t"
then
    nohup cvlc https://streaming.radionomy.com/AMERICANTOP40 > radio.log  2>&1 & 
    echo $! > save_pid.txt
    current=$choice
fi
if test "$choice" == "electro"
then
    nohup cvlc /home/radio/electroRadio1.pls > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "cl"
then
    nohup cvlc http://player.allclassical.org/streamplaylist/ac32k.pls > radio.log  2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "cl2"
then
    nohup cvlc http://199.115.115.72:30228/stream > radio.log  2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "cl3"
then
    nohup cvlc https://streaming.radionomy.com/Beethoven-Radio > radio.log  2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "cl4"
then
    nohup cvlc https://streaming.radionomy.com/ABC-Symphony > radio.log  2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "cl5"
then
    nohup cvlc https://streaming.radionomy.com/1000ClassicalHits > radio.log  2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "cl6"
then
    nohup cvlc http://199.115.115.72:30228/stream > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "jazz"
then
    nohup cvlc http://streaming211.radionomy.com:80/101SMOOTHJAZZ > radio.log  2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "latin"
then
    nohup cvlc http://streaming211.radionomy.com:80/bachata-dominicana > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "hindi"
then
    nohup cvlc http://192.240.102.133:11454 > radio.log  2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "amb1"
then
    nohup cvlc  http://5.189.142.165:2304 > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "amb2"
then
    nohup cvlc http://176.31.123.212:8192 > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi
if test "$choice" == "amb3"
then
    nohup cvlc https://streaming.radionomy.com/GuitarMe > radio.log 2>&1 & 
    echo $! > save_pid.txt
fi

if test "$choice" == "templateVlc"
then
    nohup cvlc http://player.allclassical.org/streamplaylist/ac32k.pls > my.log 2>&1 & 
    echo $! > save_pid.txt
# For omxplayer
#nohup omxplayer -o local http://hd.lagrosseradio.info:8300 > radio.log &
#top
fi
if test "$choice" == "x"
then
    read -p "Enter an ip or any string: " searchFor
    sudo cat /var/log/auth.log | grep $searchFor
fi
if test "$choice" == "q"
then
    echo "See ya!"
    exit
fi
if test "$choice" == "qr"
then
    echo "See ya!"
    kill `cat save_pid.txt`
    rm save_pid.txt
    exit
fi
if test "$choice" == "k"
then
    echo "See ya!"
    kill `cat save_pid.txt`
    rm save_pid.txt
fi
if test "$choice" == "a"
then
    echo "Volume Up"
    amixer sset 'PCM' 3dB+ 
fi
if test "$choice" == "z"
then
    echo "Volume Down"
    amixer sset 'PCM' 3dB- 
fi
if test "$choice" == "v"
then
    echo "Volume control with Alsamixer"
    echo $! > tmp.log
    alsamixer
    echo "Alsamixer started" & exit
    echo $! > mixer.log 
fi
if test "$choice" == "mute"
then
    echo "Muted"
    amixer sset 'PCM' 0% 
fi
if test "$choice" == "help"
then
    echo "###### HELP ######"
    echo "To make your own list of radio, simply add a file called"
    echo "radioList.txt"
    echo "The first column is the name without spaces and the second is the url or relative path of the file on your machine"
    echo "e.g. VPR http://radiovpr.com:8080"
    echo "Note that this url doesn't exists"
fi
#exit
i=$[$i+1]
done
echo "End of script"
exit
echo "You are not suppose to see this"
