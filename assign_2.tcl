set ns [new Simulator]

set nr [open thro.tr w]
$ns trace-all $nr
set nf [open thro.nam w]
$ns namtrace-all $nf

proc finish {} {
global ns nr nf
 $ns flush-trace
 close $nf
close $nr
exec nam thro.nam &
exit 0
}

for { set i 0 } {$i < 16} { incr i 1 } {
set n($i) [$ns node]
}

for { set i 1 } {$i < 6} { incr i 1 } {
$ns duplex-link $n($i) $n([expr $i+1]) 1Mb 10ms DropTail
}


$ns duplex-link $n(2) $n(6) 1Mb 10ms DropTail
$ns duplex-link $n(2) $n(10) 1Mb 10ms DropTail

$ns duplex-link $n(5) $n(8) 1Mb 10ms DropTail
$ns duplex-link $n(5) $n(7) 1Mb 10ms DropTail

$ns duplex-link $n(10) $n(9) 1Mb 10ms DropTail
$ns duplex-link $n(8) $n(9) 1Mb 10ms DropTail

$ns duplex-link $n(15) $n(9) 1Mb 10ms DropTail
$ns duplex-link $n(15) $n(14) 1Mb 10ms DropTail
$ns duplex-link $n(13) $n(14) 1Mb 10ms DropTail
$ns duplex-link $n(12) $n(13) 1Mb 10ms DropTail
$ns duplex-link $n(13) $n(15) 1Mb 10ms DropTail
$ns duplex-link $n(12) $n(11) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(11) 1Mb 10ms DropTail
$ns duplex-link $n(8) $n(15) 1Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n(1) $udp0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $n(7) $null0
$ns connect $udp0 $null0

set udp1 [new Agent/UDP]
$ns attach-agent $n(1) $udp1
set cbr1 [new Application/Traffic/CBR]

$cbr1 set packetSize_ 500

$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

set null1 [new Agent/Null]
$ns attach-agent $n(15) $null1
$ns connect $udp1 $null1

$ns rtproto DV

$ns rtmodel-at 2.0 down $n(2) $n(6)
$ns rtmodel-at 4.0 down $n(2) $n(10)
$ns rtmodel-at 6.0 down $n(13) $n(15)
$ns rtmodel-at 8.0 down $n(2) $n(3)

$ns rtmodel-at 7.0 up $n(2) $n(6)
$ns rtmodel-at 9.0 up $n(2) $n(10)
$ns rtmodel-at 10.0 up $n(13) $n(15)
$ns rtmodel-at 10.0 up $n(2) $n(3)

$udp0 set fid_ 1
$udp1 set fid_ 2

$ns color 1 Green
$ns color 2 Blue

$ns at 1.0 "$cbr0 start"
$ns at 1.0 "$cbr1 start"
$ns at 12 "finish"

$ns run
 

