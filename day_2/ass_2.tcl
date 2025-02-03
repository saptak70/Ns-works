# Create Simulator
set ns [new Simulator]

# Use colors to differentiate the traffic
$ns color 1 Blue
$ns color 2 Red

# Open trace and NAM trace file
set ntrace [open assignment2.tr w]
$ns trace-all $ntrace
set namfile [open assignment2.nam w]
$ns namtrace-all $namfile

# Finish Procedure
proc finish {} {
    global ns ntrace namfile
    $ns flush-trace
    close $ntrace
    close $namfile
    exec nam assignment2.nam &
    exit 0
}

# Create 12 nodes
for {set i 0} {$i < 13} {incr i} {
    set n($i) [$ns node]
}

# Create links between nodes
for {set i 0} {$i < 3} {incr i} {
    $ns duplex-link $n($i) $n([expr $i+1]) 2Mb 10ms DropTail
}

for {set i 10} {$i < 12} {incr i} {
    $ns duplex-link $n($i) $n([expr $i+1]) 2Mb 10ms DropTail
}

$ns duplex-link $n(8) $n(5) 2Mb 10ms DropTail
$ns duplex-link $n(0) $n(4) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(4) 2Mb 10ms DropTail
$ns duplex-link $n(4) $n(5) 2Mb 10ms DropTail
$ns duplex-link $n(4) $n(6) 2Mb 10ms DropTail
$ns duplex-link $n(5) $n(7) 2Mb 10ms DropTail
$ns duplex-link $n(6) $n(7) 2Mb 10ms DropTail
$ns duplex-link $n(6) $n(8) 2Mb 10ms DropTail
$ns duplex-link $n(7) $n(10) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(10) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(9) 2Mb 10ms DropTail
$ns duplex-link $n(9) $n(11) 2Mb 10ms DropTail
$ns duplex-link $n(9) $n(3) 2Mb 10ms DropTail
$ns duplex-link $n(6) $n(3) 2Mb 10ms DropTail
$ns duplex-link $n(3) $n(12) 2Mb 10ms DropTail

# Create UDP agent on node 0
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0

# Create a Null sink at node 9
set null0 [new Agent/Null]
$ns attach-agent $n(9) $null0
$ns connect $udp0 $null0

# Setup a UDP application
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set rate_ 1Mb
$cbr0 set packetSize_ 512
$udp0 set fid_ 1

# Create a TCP agent on node 1
set tcp1 [new Agent/TCP]
$ns attach-agent $n(1) $tcp1

# Create TCP sink at node 12
set sink2 [new Agent/TCPSink]
$ns attach-agent $n(12) $sink2
$ns connect $tcp1 $sink2

# Setup a TCP application
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$tcp1 set fid_ 2

# Enable Distance Vector routing
$ns rtproto DV

# Link failures
$ns rtmodel-at 2.0 down $n(8) $n(4)
$ns rtmodel-at 3.0 down $n(1) $n(2)
$ns rtmodel-at 4.0 down $n(6) $n(8)
$ns rtmodel-at 5.0 down $n(3) $n(12)

# Link restoration
$ns rtmodel-at 6.0 up $n(3) $n(12)
$ns rtmodel-at 7.0 up $n(1) $n(2)
$ns rtmodel-at 7.5 up $n(6) $n(4)

# Event Scheduling
$ns at 0.0 "$cbr0 start"
$ns at 10.0 "$cbr0 stop"
$ns at 0.1 "$ftp1 start"
$ns at 10.0 "$ftp1 stop"
$ns at 12.0 "finish"

# Run Simulation
$ns run
