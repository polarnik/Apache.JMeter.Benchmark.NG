#!/bin/bash

jmeterScriptFolder=$1
jmeterLibFolder=$2
reportFolder=$3

mkdir -p $reportFolder

jmeterPID=`pgrep -f "java.*-jar ApacheJMeter"`

while ! [ -n "$jmeterPID" ]
do
    sleep 0.1
    jmeterPID=`pgrep -f "java.*-jar ApacheJMeter"`
done

dt=`date '+%Y-%m-%d_%H-%M-%S'`
jmeterScript=`pgrep -af "java.*-jar ApacheJMeter" | awk -F "-t $jmeterScriptFolder" '{ split($2, t, " "); print t[1]}'`
sampleTraceName="$reportFolder""$jmeterScript.$dt.sdt"

echo "sjk run for $jmeterPID at $dt into $sampleTraceName"
java -jar "$jmeterLibFolder"sjk-plus-0.11.jar stcap -p $jmeterPID -o $sampleTraceName -t 600s
echo "complete $sampleTraceName"

java -jar "$jmeterLibFolder"sjk-plus-0.11.jar ssa \
    --file $sampleTraceName \
    --thread-name "Thread Group.*" \
    --histo \
    > "$sampleTraceName".histo.txt

java -jar "$jmeterLibFolder"sjk-plus-0.11.jar ssa \
    --file $sampleTraceName \
    --thread-name "Thread Group.*" \
    --histo \
    --by-term \
    > "$sampleTraceName".histo.by-term.txt

java -jar "$jmeterLibFolder"sjk-plus-0.11.jar ssa \
    --file $sampleTraceName \
    --thread-name "Thread Group.*" \
    --thread-info \
    > "$sampleTraceName".thread-info.txt

java -jar "$jmeterLibFolder"sjk-plus-0.11.jar ssa \
    --file $sampleTraceName \
    --thread-name "Thread Group.*" \
    --flame \
    --title "$jmeterScript" \
    --width 3500 \
    > "$sampleTraceName".svg