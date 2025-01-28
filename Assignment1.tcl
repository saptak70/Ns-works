
# Define simulator
set ns [new Simulator]

# Open trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

# Define nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

# Define duplex links between nodes
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

# UDP connection between n0 and n1
set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
set null [new Agent/Null]
$ns attach-agent $n1 $null
$ns connect $udp $null

# TCP connection between n1 and n2
set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink

# Create CBR traffic for UDP
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.01
$cbr attach-agent $udp

# Schedule events
$ns at 0.5 "$cbr start"
$ns at 5.0 "$cbr stop"

# Finish procedure
$ns at 6.0 "finish"
proc finish {} {
    global ns tracefile
    $ns flush-trace
    close $tracefile
    exit 0
}

# Run simulation
$ns run
