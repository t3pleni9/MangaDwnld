#!/bin/bash
clear
user=~justin
if [ -f $user/.manga_get ] 
then 
    echo "Starting Downloads"
else
    echo "Error: .manga_get not found"
    exit 1
fi
config=($(cat $user/.manga_get))
len=${#config[@]}
len=`expr $len - 1`;
tempFile="$user/$$.$RANDOM.tmp"
touch $tempFile
echo $tempFile

for (( i=0; i<=$len;  )) 
do      
    parentUrl="${config[$i]}" 
    url="${config[$i+1]}" 
    chapter="${config[$i+2]}" 
    i=`expr $i+3`    
    page=$(wget -qO- "$parentUrl/$url/chapter/$chapter")

    linkLine=$(echo "$page"|grep "img style=\"cursor: pointer;\""|tr ' ' '\n'|grep -oh "http://[a-zA-Z0-9/\.%_-]*"|tr -d ' \t\n\r\f') #regex needs to be updated as required
    if [ -z $linkLine ]
    then
        echo "No file to download"        
    else     
        totChap=$(echo "$page"|grep -o  "value=\"[a-zA-Z0-9/_\.-]*/chapter/$chapter/[[:digit:]]*"|wc -l)
        imageURLs=$($user/urlGenerator.pl $linkLine $totChap)
        mkdir -p "$user/$url/$chapter"
        cd "$user/$url/$chapter"
        for key in $imageURLs; do 
            wget $key
        done
        notify-send 'New Manga Download Complete' "~/$url/$chapter/" --icon=dialog-information
        chapter=`expr $chapter + 1`;
    fi
    echo $parentUrl >> $tempFile
    echo $url >> $tempFile
    echo $chapter >> $tempFile
done
rm "$user/.manga_get"
mv "$tempFile" "$user/.manga_get"
exit 1

