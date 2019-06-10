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

echo "sjk.hh run for $jmeterPID at $dt into $sampleTraceName"
java -jar "$jmeterLibFolder"sjk-plus-0.11.jar \
    hh \
    --pid $jmeterPID \
    > "$sampleTraceName".hh.txt

java -jar "$jmeterLibFolder"sjk-plus-0.11.jar \
    hh \
    --pid $jmeterPID \
    --dead \
    > "$sampleTraceName".hh.dead.txt

java -jar "$jmeterLibFolder"sjk-plus-0.11.jar \
    hh \
    --pid $jmeterPID \
    --dead-young \
    > "$sampleTraceName".hh.dead-young.txt

java -jar "$jmeterLibFolder"sjk-plus-0.11.jar \
    hh \
    --pid $jmeterPID \
    --live \
    > "$sampleTraceName".hh.live.txt

while [ -n "$jmeterPID" ]
do

jmeterScript=`pgrep -af "java.*-jar ApacheJMeter" | awk -F "-t $jmeterScriptFolder" '{ split($2, t, " "); print t[1]}'`

echo "sjk.hh run for $jmeterPID with $jmeterScript"
java -jar "$jmeterLibFolder"sjk-plus-0.11.jar \
    hh \
    --pid $jmeterPID | \
    grep -E "^[ ]*[0-9]+:[ ]+[0-9]+" | \
    head -n 500 | \
    awk -v app=Apache.JMeter -v param="$jmeterScript" -f sjk.hh.2.influx.awk | \
    curl -i -XPOST "http://localhost:8086/write?db=sjk" --data-binary @-

#   #      Instances          Bytes  Type
#   1:         36881        4559712  [C
#   2:          1718        1342632  [B
#   3:         36643         879432  java.lang.String
#   4:          5347         605336  java.lang.Class

    sleep 5.0
    jmeterPID=`pgrep -f "java.*-jar ApacheJMeter"`
done

