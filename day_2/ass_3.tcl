# Create Simulator
set ns [new Simulator]

# Use colors to differentiate the traffic
$ns color 1 Blue
$ns color 2 Red

# Open trace and NAM trace file
set ntrace [open assignment3.tr w]
$ns trace-all $ntrace
set namfile [open assignment3.nam w]
$ns namtrace-all $namfile

# Finish Procedure
proc finish {} {
    global ns ntrace namfile
    $ns flush-trace
    close $ntrace
    close $namfile
    exec nam assignment3.nam &
    exit 0
}

# Create 8 nodes
for {set i 0} {$i < 8} {incr i} {
    set n($i) [$ns node]
}

# Create network topology (duplex links)
for {set i 0} {$i < 5} {incr i} {
    $ns duplex-link $n($i) $n([expr $i+1]) 2Mb 10ms DropTail
}
$ns duplex-link $n(0) $n(6) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(7) 2Mb 10ms DropTail
$ns duplex-link $n(2) $n(5) 2Mb 10ms DropTail
$ns duplex-link $n(3) $n(7) 2Mb 10ms DropTail
$ns duplex-link $n(4) $n(6) 2Mb 10ms DropTail

# Link orientation
$ns duplex-link-op $n(2) $n(3) orient down
$ns duplex-link-op $n(3) $n(4) orient right-down
$ns duplex-link-op $n(4) $n(5) orient right
$ns duplex-link-op $n(5) $n(6) orient right
$ns duplex-link-op $n(6) $n(7) orient right
$ns duplex-link-op $n(7) $n(2) orient right-up
$ns duplex-link-op $n(6) $n(0) orient right-down

# Create UDP traffic sources
for {set i 0} {$i < 5} {incr i} {
    set udp($i) [new Agent/UDP]
    $ns attach-agent $n($i) $udp($i)]

    set null($i) [new Agent/Null]
    $ns attach-agent $n([expr $i+1]) $null($i)
    
    $ns connect $udp($i) $null($i)

    set cbr($i) [new Application/Traffic/CBR]
    $cbr($i) attach-agent $udp($i)
    $cbr($i) set rate_ 1Mb
    $cbr($i) set packetSize_ 512
    $udp($i) set fid_ 1
}

# Create TCP agent on node 1
set tcp1 [new Agent/TCP]
$ns attach-agent $n(1) $tcp1

# Create TCP sink at node 0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n(0) $sink1
$ns connect $tcp1 $sink1

# Setup TCP application
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$tcp1 set fid_ 2

# Schedule events
for {set i 0} {$i < 5} {incr i} {
    $ns at 0.5 "$cbr($i) start"
    $ns at 10.0 "$cbr($i) stop"
}

$ns at 12.0 "finish"
$ns run
