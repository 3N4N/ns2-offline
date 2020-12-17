# simulator
set ns [new Simulator]


# ======================================================================
# Define options

set val(chan)         Channel/WirelessChannel  ;# channel type
set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna      ;# Antenna type
set val(ll)           LL                       ;# Link layer type
set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
set val(ifqlen)       50                       ;# max packet in ifq
set val(netif)        Phy/WirelessPhy          ;# network interface type
set val(mac)          Mac/802_11               ;# MAC type
set val(rp)           DSDV                     ;# ad-hoc routing protocol
set val(nn)           2                        ;# number of mobilenodes
# =======================================================================

# trace file
set trace_file [open trace.tr w]
$ns trace-all $trace_file

# nam file
set nam_file [open animation.nam w]
$ns namtrace-all-wireless $nam_file 500 500

# topology: to keep track of node movements
set topo [new Topography]
$topo load_flatgrid 500 500 ;# 500m x 500m area


# general operation director for mobilenodes
create-god $val(nn)


# node configs
# ======================================================================

# $ns node-config -addressingType flat or hierarchical or expanded
#                  -adhocRouting   DSDV or DSR or TORA
#                  -llType     LL
#                  -macType    Mac/802_11
#                  -propType       "Propagation/TwoRayGround"
#                  -ifqType    "Queue/DropTail/PriQueue"
#                  -ifqLen     50
#                  -phyType    "Phy/WirelessPhy"
#                  -antType    "Antenna/OmniAntenna"
#                  -channelType    "Channel/WirelessChannel"
#                  -topoInstance   $topo
#                  -energyModel    "EnergyModel"
#                  -initialEnergy  (in Joules)
#                  -rxPower        (in W)
#                  -txPower        (in W)
#                  -agentTrace     ON or OFF
#                  -routerTrace    ON or OFF
#                  -macTrace       ON or OFF
#                  -movementTrace  ON or OFF

# ======================================================================

$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -channelType $val(chan) \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF

# create nodes
set node(0) [$ns node]
$node(0) random-motion 0       ;# disable random motion
$node(0) set X_ 200
$node(0) set Y_ 200
$node(0) set Z_ 0
$ns initial_node_pos $node(0) 20

set node(1) [$ns node]
$node(1) random-motion 0       ;# disable random motion
$node(1) set X_ 200
$node(1) set Y_ 400
$node(1) set Z_ 0
$ns initial_node_pos $node(1) 20




# Traffic config
# create agent
set tcp [new Agent/TCP]
set tcp_sink [new Agent/TCPSink]
# attach to nodes
$ns attach-agent $node(0) $tcp
$ns attach-agent $node(1) $tcp_sink
# connect agents
$ns connect $tcp $tcp_sink
$tcp set fid_ 0

# Traffic generator
set ftp [new Application/FTP]
# attach to agent
$ftp attach-agent $tcp

# start traffic generation
$ns at 1.0 "$ftp start"



# End Simulation

# Stop nodes

$ns at 50.0 "$node(0) reset"
$ns at 50.0 "$node(1) reset"


# call final function
proc finish {} {
    global ns trace_file nam_file
    $ns flush-trace
    close $trace_file
    close $nam_file
}

proc halt_simulation {} {
    global ns
    puts "Simulation ending"
    $ns halt
}

$ns at 50.0001 "finish"
$ns at 50.0002 "halt_simulation"




# Run simulation
puts "Simulation starting"
$ns run

