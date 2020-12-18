#!/bin/env bash

if [ ! -f src/parse.awk ] || [ ! -f src/wireless.tcl ]; then
    echo 'The parser or the tcl is not found.'
    exit
fi

if [ ! -d bin ]; then
    mkdir -p bin
fi

areas=(250 500 750 1000 1250)
nodes=(20 40 60 80 100)
flows=(10 20 30 40 50)

for i in {1..5}; do
    j=$(($i - 1))

    # printf "${areas[$j]} ${nodes[$j]} ${flows[$j]}\n"

    ns src/wireless.tcl ${areas[$j]}    40              20              bin/area-$i.tr bin/area-$i.nam
    ns src/wireless.tcl 500             ${nodes[$j]}    20              bin/node-$i.tr bin/node-$i.nam
    ns src/wireless.tcl 500             40              ${flows[$j]}    bin/flow-$i.tr bin/flow-$i.nam

    awk -f src/parse.awk bin/area-$i.tr > bin/area-$i.txt
    awk -f src/parse.awk bin/node-$i.tr > bin/node-$i.txt
    awk -f src/parse.awk bin/flow-$i.tr > bin/flow-$i.txt
done

printf "title_x = Area\ntitle_y = Throughput\n" > bin/thru-area.xg
printf "title_x = Node\ntitle_y = Throughput\n" > bin/thru-node.xg
printf "title_x = Flow\ntitle_y = Throughput\n" > bin/thru-flow.xg
printf "title_x = Area\ntitle_y = Avg. Delay\n" > bin/dlay-area.xg
printf "title_x = Node\ntitle_y = Avg. Delay\n" > bin/dlay-node.xg
printf "title_x = Flow\ntitle_y = Avg. Delay\n" > bin/dlay-flow.xg
printf "title_x = Area\ntitle_y = Delivery\n" > bin/dlvr-area.xg
printf "title_x = Node\ntitle_y = Delivery Ratio\n" > bin/dlvr-node.xg
printf "title_x = Flow\ntitle_y = Delivery Ratio\n" > bin/dlvr-flow.xg
printf "title_x = Area\ntitle_y = Drop Ratio\n" > bin/drop-area.xg
printf "title_x = Node\ntitle_y = Drop Ratio\n" > bin/drop-node.xg
printf "title_x = Flow\ntitle_y = Drop Ratio\n" > bin/drop-flow.xg

for i in {1..5}; do
    j=$(($i - 1))
    echo ${areas[$j]} $(grep -w Throughput bin/area-$i.txt | awk '{print $2}') >> bin/thru-area.xg
    echo ${nodes[$j]} $(grep -w Throughput bin/node-$i.txt | awk '{print $2}') >> bin/thru-node.xg
    echo ${flows[$j]} $(grep -w Throughput bin/flow-$i.txt | awk '{print $2}') >> bin/thru-flow.xg
    echo ${areas[$j]} $(grep -w Delay bin/area-$i.txt | awk '{print $3}') >> bin/dlay-area.xg
    echo ${nodes[$j]} $(grep -w Delay bin/node-$i.txt | awk '{print $3}') >> bin/dlay-node.xg
    echo ${flows[$j]} $(grep -w Delay bin/flow-$i.txt | awk '{print $3}') >> bin/dlay-flow.xg
    echo ${areas[$j]} $(grep -w Delivery bin/area-$i.txt | awk '{print $3}') >> bin/dlvr-area.xg
    echo ${nodes[$j]} $(grep -w Delivery bin/node-$i.txt | awk '{print $3}') >> bin/dlvr-node.xg
    echo ${flows[$j]} $(grep -w Delivery bin/flow-$i.txt | awk '{print $3}') >> bin/dlvr-flow.xg
    echo ${areas[$j]} $(grep -w Drop bin/area-$i.txt | awk '{print $3}') >> bin/drop-area.xg
    echo ${nodes[$j]} $(grep -w Drop bin/node-$i.txt | awk '{print $3}') >> bin/drop-node.xg
    echo ${flows[$j]} $(grep -w Drop bin/flow-$i.txt | awk '{print $3}') >> bin/drop-flow.xg
done
