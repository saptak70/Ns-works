# Create Simulator
set ns [new Simulator]

# Use colors to differentiate the traffic
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Yellow

# Open trace and NAM trace files
set ntrace [open assignment1.tr w]
$ns trace-all $ntrace
set namfile [open assignment1.nam w]
$ns namtrace-all $namfile

# Finish Procedure
proc finish {} {
    global ns ntrace namfile
    # Dump all trace data and close the files
    $ns flush-trace
    close $ntrace
    close $namfile
    # Execute the nam animation file
    exec nam assignment1.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

# Create duplex links between the nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail

# Link orientations
$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n2 orient right-down

# Create UDP agent on node 0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# Create a Null sink at node 1
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
$ns connect $udp0 $null0

# Create UDP agent on node 1
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

# Create a Null sink at node 0
set null1 [new Agent/Null]
$ns attach-agent $n0 $null1
$ns connect $udp1 $null1

# Create a TCP agent on node 1
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

# Create TCP sink at node 2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $sink2
$ns connect $tcp1 $sink2

# Setup a UDP application
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set rate_ 1Mb
$cbr0 set packetSize_ 512
$udp0 set fid_ 1

# Setup another UDP application
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set rate_ 1Mb
$cbr1 set packetSize_ 512
$udp1 set fid_ 3

# Setup a TCP application
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$tcp1 set fid_ 2

# Simulation start/stop times
$ns at 1.0 "$cbr0 start"
$ns at 2.0 "$cbr0 stop"
$ns at 1.5 "$cbr1 start"
$ns at 2.5 "$cbr1 stop"
$ns at 0.5 "$ftp1 start"
$ns at 1.5 "$ftp1 stop"

# Call finish at 3.0 sec
$ns at 3.0 "finish"

# Run the simulation
$ns run
