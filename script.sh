#!/bin/env bash

if [ ! -f src/parse.awk ] || [ ! -f src/wireless.tcl ]; then
    echo 'The parser or the tcl is not found.'
    exit
fi

ns src/wireless.tcl 250  40 20 bin/area-1.tr bin/area-1.nam
ns src/wireless.tcl 500  40 20 bin/area-2.tr bin/area-2.nam
ns src/wireless.tcl 750  40 20 bin/area-3.tr bin/area-3.nam
ns src/wireless.tcl 1000 40 20 bin/area-4.tr bin/area-4.nam
ns src/wireless.tcl 1250 40 20 bin/area-5.tr bin/area-5.nam

ns src/wireless.tcl 500 20  20 bin/node-1.tr bin/node-1.nam
ns src/wireless.tcl 500 40  20 bin/node-2.tr bin/node-2.nam
ns src/wireless.tcl 500 60  20 bin/node-3.tr bin/node-3.nam
ns src/wireless.tcl 500 80  20 bin/node-4.tr bin/node-4.nam
ns src/wireless.tcl 500 100 20 bin/node-5.tr bin/node-5.nam

ns src/wireless.tcl 500 40 10 bin/flow-1.tr bin/flow-1.nam
ns src/wireless.tcl 500 40 20 bin/flow-2.tr bin/flow-2.nam
ns src/wireless.tcl 500 40 30 bin/flow-3.tr bin/flow-3.nam
ns src/wireless.tcl 500 40 40 bin/flow-4.tr bin/flow-4.nam
ns src/wireless.tcl 500 40 50 bin/flow-5.tr bin/flow-5.nam

awk -f src/parse.awk bin/area-1.tr > bin/area-1.txt
awk -f src/parse.awk bin/area-2.tr > bin/area-2.txt
awk -f src/parse.awk bin/area-3.tr > bin/area-3.txt
awk -f src/parse.awk bin/area-4.tr > bin/area-4.txt
awk -f src/parse.awk bin/area-5.tr > bin/area-5.txt

awk -f src/parse.awk bin/node-1.tr > bin/node-1.txt
awk -f src/parse.awk bin/node-2.tr > bin/node-2.txt
awk -f src/parse.awk bin/node-3.tr > bin/node-3.txt
awk -f src/parse.awk bin/node-4.tr > bin/node-4.txt
awk -f src/parse.awk bin/node-5.tr > bin/node-5.txt

awk -f src/parse.awk bin/flow-1.tr > bin/flow-1.txt
awk -f src/parse.awk bin/flow-2.tr > bin/flow-2.txt
awk -f src/parse.awk bin/flow-3.tr > bin/flow-3.txt
awk -f src/parse.awk bin/flow-4.tr > bin/flow-4.txt
awk -f src/parse.awk bin/flow-5.tr > bin/flow-5.txt

printf "title_x = Area\ntitle_y = Throughput\n" > bin/thru-area.xg
echo $(grep -w Throughput bin/area-1.txt | awk '{print $2}') 250  >> bin/thru-area.xg
echo $(grep -w Throughput bin/area-2.txt | awk '{print $2}') 500  >> bin/thru-area.xg
echo $(grep -w Throughput bin/area-3.txt | awk '{print $2}') 750  >> bin/thru-area.xg
echo $(grep -w Throughput bin/area-4.txt | awk '{print $2}') 1000 >> bin/thru-area.xg
echo $(grep -w Throughput bin/area-5.txt | awk '{print $2}') 1250 >> bin/thru-area.xg

printf "title_x = Node\ntitle_y = Throughput\n" > bin/thru-node.xg
echo $(grep -w Throughput bin/node-1.txt | awk '{print $2}') 20  >> bin/thru-node.xg
echo $(grep -w Throughput bin/node-2.txt | awk '{print $2}') 40  >> bin/thru-node.xg
echo $(grep -w Throughput bin/node-3.txt | awk '{print $2}') 60  >> bin/thru-node.xg
echo $(grep -w Throughput bin/node-4.txt | awk '{print $2}') 80  >> bin/thru-node.xg
echo $(grep -w Throughput bin/node-5.txt | awk '{print $2}') 100 >> bin/thru-node.xg

printf "title_x = Flow\ntitle_y = Throughput\n" > bin/thru-flow.xg
echo $(grep -w Throughput bin/flow-1.txt | awk '{print $2}') 10 >> bin/thru-flow.xg
echo $(grep -w Throughput bin/flow-2.txt | awk '{print $2}') 20 >> bin/thru-flow.xg
echo $(grep -w Throughput bin/flow-3.txt | awk '{print $2}') 30 >> bin/thru-flow.xg
echo $(grep -w Throughput bin/flow-4.txt | awk '{print $2}') 40 >> bin/thru-flow.xg
echo $(grep -w Throughput bin/flow-5.txt | awk '{print $2}') 50 >> bin/thru-flow.xg

printf "title_x = Area\ntitle_y = Avg\n" > bin/dlay-area.xg
echo $(grep -w Delay bin/area-1.txt | awk '{print $3}') 250  >> bin/dlay-area.xg
echo $(grep -w Delay bin/area-2.txt | awk '{print $3}') 500  >> bin/dlay-area.xg
echo $(grep -w Delay bin/area-3.txt | awk '{print $3}') 750  >> bin/dlay-area.xg
echo $(grep -w Delay bin/area-4.txt | awk '{print $3}') 1000 >> bin/dlay-area.xg
echo $(grep -w Delay bin/area-5.txt | awk '{print $3}') 1250 >> bin/dlay-area.xg

printf "title_x = Node\ntitle_y = Avg\n" > bin/dlay-node.xg
echo $(grep -w Delay bin/node-1.txt | awk '{print $3}') 20  >> bin/dlay-node.xg
echo $(grep -w Delay bin/node-2.txt | awk '{print $3}') 40  >> bin/dlay-node.xg
echo $(grep -w Delay bin/node-3.txt | awk '{print $3}') 60  >> bin/dlay-node.xg
echo $(grep -w Delay bin/node-4.txt | awk '{print $3}') 80  >> bin/dlay-node.xg
echo $(grep -w Delay bin/node-5.txt | awk '{print $3}') 100 >> bin/dlay-node.xg

printf "title_x = Flow\ntitle_y = Avg\n" > bin/dlay-flow.xg
echo $(grep -w Delay bin/flow-1.txt | awk '{print $3}') 10 >> bin/dlay-flow.xg
echo $(grep -w Delay bin/flow-2.txt | awk '{print $3}') 20 >> bin/dlay-flow.xg
echo $(grep -w Delay bin/flow-3.txt | awk '{print $3}') 30 >> bin/dlay-flow.xg
echo $(grep -w Delay bin/flow-4.txt | awk '{print $3}') 40 >> bin/dlay-flow.xg
echo $(grep -w Delay bin/flow-5.txt | awk '{print $3}') 50 >> bin/dlay-flow.xg

printf "title_x = Area\ntitle_y = Delivery\n" > bin/dlvr-area.xg
echo $(grep -w Delivery bin/area-1.txt | awk '{print $3}') 250  >> bin/dlvr-area.xg
echo $(grep -w Delivery bin/area-2.txt | awk '{print $3}') 500  >> bin/dlvr-area.xg
echo $(grep -w Delivery bin/area-3.txt | awk '{print $3}') 750  >> bin/dlvr-area.xg
echo $(grep -w Delivery bin/area-4.txt | awk '{print $3}') 1000 >> bin/dlvr-area.xg
echo $(grep -w Delivery bin/area-5.txt | awk '{print $3}') 1250 >> bin/dlvr-area.xg

printf "title_x = Node\ntitle_y = Delivery Ratio\n" > bin/dlvr-node.xg
echo $(grep -w Delivery bin/node-1.txt | awk '{print $3}') 20  >> bin/dlvr-node.xg
echo $(grep -w Delivery bin/node-2.txt | awk '{print $3}') 40  >> bin/dlvr-node.xg
echo $(grep -w Delivery bin/node-3.txt | awk '{print $3}') 60  >> bin/dlvr-node.xg
echo $(grep -w Delivery bin/node-4.txt | awk '{print $3}') 80  >> bin/dlvr-node.xg
echo $(grep -w Delivery bin/node-5.txt | awk '{print $3}') 100 >> bin/dlvr-node.xg

printf "title_x = Flow\ntitle_y = Delivery Ratio\n" > bin/dlvr-flow.xg
echo $(grep -w Delivery bin/flow-1.txt | awk '{print $3}') 10 >> bin/dlvr-flow.xg
echo $(grep -w Delivery bin/flow-2.txt | awk '{print $3}') 20 >> bin/dlvr-flow.xg
echo $(grep -w Delivery bin/flow-3.txt | awk '{print $3}') 30 >> bin/dlvr-flow.xg
echo $(grep -w Delivery bin/flow-4.txt | awk '{print $3}') 40 >> bin/dlvr-flow.xg
echo $(grep -w Delivery bin/flow-5.txt | awk '{print $3}') 50 >> bin/dlvr-flow.xg

printf "title_x = Area\ntitle_y = Drop Ratio\n" > bin/drop-area.xg
echo $(grep -w Drop bin/area-1.txt | awk '{print $3}') 250  >> bin/drop-area.xg
echo $(grep -w Drop bin/area-2.txt | awk '{print $3}') 500  >> bin/drop-area.xg
echo $(grep -w Drop bin/area-3.txt | awk '{print $3}') 750  >> bin/drop-area.xg
echo $(grep -w Drop bin/area-4.txt | awk '{print $3}') 1000 >> bin/drop-area.xg
echo $(grep -w Drop bin/area-5.txt | awk '{print $3}') 1250 >> bin/drop-area.xg

printf "title_x = Node\ntitle_y = Drop Ratio\n" > bin/drop-node.xg
echo $(grep -w Drop bin/node-1.txt | awk '{print $3}') 20  >> bin/drop-node.xg
echo $(grep -w Drop bin/node-2.txt | awk '{print $3}') 40  >> bin/drop-node.xg
echo $(grep -w Drop bin/node-3.txt | awk '{print $3}') 60  >> bin/drop-node.xg
echo $(grep -w Drop bin/node-4.txt | awk '{print $3}') 80  >> bin/drop-node.xg
echo $(grep -w Drop bin/node-5.txt | awk '{print $3}') 100 >> bin/drop-node.xg

printf "title_x = Flow\ntitle_y = Drop Ratio\n" > bin/drop-flow.xg
echo $(grep -w Drop bin/flow-1.txt | awk '{print $3}') 10 >> bin/drop-flow.xg
echo $(grep -w Drop bin/flow-2.txt | awk '{print $3}') 20 >> bin/drop-flow.xg
echo $(grep -w Drop bin/flow-3.txt | awk '{print $3}') 30 >> bin/drop-flow.xg
echo $(grep -w Drop bin/flow-4.txt | awk '{print $3}') 40 >> bin/drop-flow.xg
echo $(grep -w Drop bin/flow-5.txt | awk '{print $3}') 50 >> bin/drop-flow.xg
