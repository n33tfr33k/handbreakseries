#!/bin/bash
# copyrights this guy http://ubuntuforums.org/showthread.php?t=1544346 and changes by https://gist.github.com/jensbocklage
# ripdvd.sh
# input must be:
#    - <devicename> (which can be anything lsdvd takes)
#    - <outputfolder> where do you want the ripped series
#    - <outputname> the base name of the output
#    - <startsfrom> where to start counting if you use 0 it starts at 1 
#	(useful for seasons spanning over multiple disks)

INPUT_DVD=$1
OUTPUT_FOLDER=$2
OUTPUT_NAME=$3
STARTS_FROM=$4

LSDVDOUTPUT=$(lsdvd "$1")

# if available get the title and get the number of titles
TITLE=$(echo "$LSDVDOUTPUT" | grep -i Disc | sed 's/Disc Title: //g')
NOMTITLES=$(echo "$LSDVDOUTPUT" | grep -i Length | wc -l)
echo $NOMTITLES

# iterate over each title
for (( c=1; c <= $NOMTITLES+1; c++ )) do
        PREFIX=''
	# Allows for seasons on multiple DVDs
	let n=$c+$STARTS_FROM
        if [ $n -lt  10 ]; then PREFIX="0" ; fi
	OUTPUT_NAME_TITLE=$OUTPUT_FOLDER"/"$OUTPUT_NAME$PREFIX$n".mkv"
        HandBrakeCLI -i $INPUT_DVD -o $OUTPUT_NAME_TITLE -t $c -a 1,2,3,4,5 -f mkv  --deinterlace="slower" --denoise="medium" --deblock=5 --crop 0:0:0:0 --strict-anamorphic  --modulus 2 -e x264 -q 20 --cfr --encoder-preset=veryslow  --encoder-tune="film"  --encoder-level="3.1"  --encoder-profile=high
	exit
done
