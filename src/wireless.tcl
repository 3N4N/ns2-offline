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
# set val(netif)        Phy/WirelessPhy/802_15_4 ;# network interface type
# set val(mac)          Mac/802_15_4             ;# MAC type
set val(rp)           DSDV                     ;# ad-hoc routing protocol
set val(nn)           40                       ;# number of mobilenodes
set val(nf)           20                ;# number of flows
set grid_dim          500
set val(tf)           bin/trace.tr
set val(af)           bin/animation.nam

# https://www.linuxquestions.org/questions/showthread.php?s=94af03f6eb61ab5e0a38e0b7f071ef03&p=6196715&fbclid=IwAR23SGP1Sdt4-e1pabLB7WwkJrrfuET-vmQzW3bc0KV5YYHWWIaLtcZnmrs#post6196715
set val(energymodel_15) EnergyModel ;
set val(initialenergy_15) 3.0 ;# Initial energy in Joules
set val(idlepower_15) 0.45 ;#LEAP (802.11g)
set val(rxpower_15) 0.9 ;#LEAP (802.11g)
set val(txpower_15) 0.5 ;#LEAP (802.11g)
set val(sleeppower_15) 0.05 ;#LEAP (802.11g)

# =======================================================================

if { $::argc > 0 } {
    set grid_dim [lindex $argv 0]
    set val(nn)  [lindex $argv 1]
    set val(nf)  [lindex $argv 2]
    set val(tf)  [lindex $argv 3]
    set val(af)  [lindex $argv 4]
    # puts $grid_dim
    # puts $val(nn)
    # puts $val(nf)
    # exit
}


exec mkdir -p -- bin

# trace file
set trace_file [open $val(tf) w]
$ns trace-all $trace_file

# nam file
set nam_file [open $val(af) w]
$ns namtrace-all-wireless $nam_file $grid_dim $grid_dim

# topology: to keep track of node movements
set topo [new Topography]
$topo load_flatgrid $grid_dim $grid_dim ;# 500m x 500m area


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
                # -energyModel $val(energymodel_15) \
                # -idlePower $val(idlepower_15) \
                # -rxPower $val(rxpower_15) \
                # -txPower $val(txpower_15) \
                # -sleepPower $val(sleeppower_15) \
                # -initialEnergy $val(initialenergy_15)\
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF

proc randnum {min max} {
    set range [expr {$max - $min + 1}]
    return [expr {$min + int(rand() * $range)}]
}

# create nodes
# for {set i 0} {$i < $val(nn) } {incr i} {
#     set node($i) [$ns node]
#     $node($i) random-motion 0       ;# disable random motion

#     $node($i) set X_ [expr ($grid_dim * $i) / $val(nn)]
#     $node($i) set Y_ [expr ($grid_dim * $i) / $val(nn)]
#     $node($i) set Z_ 0

#     $ns initial_node_pos $node($i) 20
# }

for {set i 0} {$i < $val(nn)} {incr i} {
    set node($i) [$ns node]
    $node($i) random-motion 0

    # Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
    set x_pos [expr int($grid_dim*rand())] ; #random settings
    set y_pos [expr int($grid_dim*rand())] ; #random settings

    while {$x_pos == 0 || $x_pos == $grid_dim} {
        set x_pos [expr int($grid_dim*rand())]
    }

    while {$y_pos == 0 || $y_pos == $grid_dim} {
        set y_pos [expr int($grid_dim*rand())]
    }

    $node($i) set X_ $x_pos;
    $node($i) set Y_ $y_pos;
    $node($i) set Z_ 0.0

    $ns at 1.0 "$node($i) setdest [randnum 1 [ expr int($grid_dim - 1)]] [randnum 1 [ expr int($grid_dim - 1)]] [randnum 1 5]"
    $ns initial_node_pos $node($i) 20
}



# Traffic

set src [ randnum 0 [expr $val(nn) - 1]]
for {set i 0} {$i < $val(nf)} {incr i} {
    # set src $i
    # set dest [expr $i + 10]

    set dest [ randnum 0 [expr $val(nn) - 1]]
    while { $src == $dest } {
        set src [ randnum 0 [expr $val(nn) - 1]]
    }

    # Traffic config
    # create agent
    set tcp [new Agent/TCP]
    set tcp_sink [new Agent/TCPSink]
    # attach to nodes
    $ns attach-agent $node($src) $tcp
    $ns attach-agent $node($dest) $tcp_sink
    # connect agents
    $ns connect $tcp $tcp_sink
    $tcp set fid_ $i

    # Traffic generator
    set ftp [new Application/Telnet]
    # attach to agent
    $ftp attach-agent $tcp

    # start traffic generation
    $ns at 1.0 "$ftp start"
}



# End Simulation

# Stop nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at 50.0 "$node($i) reset"
}

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
