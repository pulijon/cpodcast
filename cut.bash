#! /bin/bash
devdir=$(dirname $0)

ffmpeg -i $1 -f segment -segment_time $2 -segment_start_number 1 -c copy ${3}_%03d.mp3
i=1
numtracks=$(ls ${3}_???.mp3 | wc -l)

for track in ${3}_???.mp3
do
	ffmpeg -i "concat:$devdir/corte_$i.mp3|$devdir/de_$numtracks.mp3|$track" \
		-c:a libmp3lame \
		-ar 44100 \
		-ac 2 \
		-metadata "title=$3" \
		-metadata "track=$(printf '%03d' $i)/$(printf '%03d' $numtracks)" \
		T_$track 
		# -i $track
		# -map_metadata 0:1
	echo $i/$numtracks
	if [ ! -z $4 ] && [ -d $4 ]
	then
		echo Copiando T_$track a $4
		cp T_$track $4
	fi
	((i+=1))
done
