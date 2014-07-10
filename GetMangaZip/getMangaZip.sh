#!/bin/bash
#clear
if [ -f .manga_get ] 
then 
    echo "Starting Downloads"
else
    echo "Error: .manga_get not found"
    exit 1
fi
config=($(cat ~/.manga_get))
len=${#config[@]}
len=`expr $len - 1`;
tempFile="$$.$RANDOM.tmp"
touch $tempFile
echo $tempFile

for (( i=0; i<=$len;  )) 
do      
    parentUrl="${config[$i]}" 
    url="${config[$i+1]}" 
    chapter="${config[$i+2]}" 
    i=`expr $i+3`     
    page=$(wget -qO- "$parentUrl/$url/chapter/$chapter")

    linkLine=$(echo "$page"|grep "a style=\"text-decoration:none;color:#0b80b8\" href="|tr ' ' '\n'|grep -oh "http://[a-zA-Z0-9/\.%_-]*"|tr -d ' \t\n\r\f') #regex needs to be updated as required
    if [ -z $linkLine ]
    then
        echo "No file to download"        
    else 
        mkdir -p "~/$url/$chapter"
        cd "~/$url/$chapter"
        wget "--quiet" $linkLine "temp.zip"
        if [ -f "temp.zip" ]
        then
            unzip "-q temp.zip"
            rm "temp.zip"
            chapter=`expr $chapter + 1`;
            notify-send 'New Manga Download Complete' "~/$url/$chapter/" --icon=dialog-information
        fi        
    fi
    echo $parentUrl >> $tempFile
    echo $url >> $tempFile
    echo $chapter >> $tempFile
done
rm ".manga_get"
mv "$tempFile" ".manga_get"
exit 1

