#! /bin/bash
#
# Script to cut mp3 files in fragments of specified sizes
#
# Author: José Miguel Robles
#
# Date: July, 2022
# 
# Use:
# cut.bash <file> <seconds> <album> <directory> <text>
#
# Description:
# Cut the mp3 <file> in fragments of <seconds> size, tagging the results as tracks
# of the album <album> and copy them in <directory> that is intended to be a
# folder of a removable storage (mp3 pod, cd, etc.) that allows sequential playing
# All the tracks include a voice that informs the number of track and <text>
# to identify by an audio prefix the fragment


# Cut or file in fragments
ffmpeg -i $1 -f segment -segment_time $2 -segment_start_number 1 -c copy ${3}_%03d.mp3

# Obtain the number of fragments
numtracks=$(printf "%03d" $(ls ${3}_???.mp3 | wc -l))

for track in ${3}_???.mp3
do
	# For each fragment
	# Obtaining number of track
	ntrack=$(echo $track | awk '{ sub(/.*_/,""); sub(/\.mp3/,""); print }')

	# Obtaining the speech prefix using the Google service
	gtts-cli "Corte $((10#$ntrack)) de $((10#$numtracks)). $5 " -l es --output pre_$track
    
	# Aggregating the prefix to the fragment
	concat_str="concat:pre_$track|$track"
	ffmpeg -i "$concat_str" \
		-c:a libmp3lame \
		-ar 44100 \
		-ac 2 \
		T_$track 
	
	# Tagging the fragment
	id3tool -a $3 \
	        -c "10#$ntrack" \
			-t "Corte $ntrack de $numtracks" \
			T_$track
	
	# Copying to directory avoiding buffer optimizations of OS that could interfere with the order
	sync T_$track
	if [ ! -z $4 ] && [ -d $4 ]
	then
		echo Copying T_$track a $4
		cp T_$track $4
		sync $4/T_$track
	fi
done
