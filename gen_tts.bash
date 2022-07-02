for i in $(seq -f "%2.0f" 1 99)
do
    echo Generando MP3 corte $i y de $i
    gtts-cli "corte $i" -l es --output corte_$i.mp3
    gtts-cli "de $i" -l es --output de_$i.mp3
done