#! /bin/bash
devdir=$(dirname $0)

ffmpeg -i $1 -f segment -segment_time $2 -segment_start_number 1 -c copy ${3}_%03d.mp3
i=1
numtracks=$(ls ${3}_???.mp3 | wc -l)

for track in ${3}_???.mp3
do
	if [ -z $5 ]
	then
	    concat_str="concat:$devdir/corte_$i.mp3|$devdir/de_$numtracks.mp3|$track"
	else
		gtts-cli "Corte $i de $numtracks. $5 " -l es --output pre_$track
		concat_str="concat:pre_$track|$track"
	fi
	ffmpeg -i "$concat_str" \
		-c:a libmp3lame \
		-ar 44100 \
		-ac 2 \
		T_$track 
		# -i $track
		# -map_metadata 0:1
	ntrack=$(printf "%03d" $i)
	id3tool -a $3 \
	        -c "$ntrack/$numtracks" \
			-t "Corte $ntrack de $numtracks" \
			T_$track
	sync T_$track
	echo $i/$numtracks
	if [ ! -z $4 ] && [ -d $4 ]
	then
		echo Copiando T_$track a $4
		cp T_$track $4
		sync $4/T_$track
	fi
	((i+=1))
done
