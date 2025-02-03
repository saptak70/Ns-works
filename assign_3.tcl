set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

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

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]

$ns duplex-link $n4 $n1 1Mb 10ms DropTail
$ns duplex-link $n3 $n1 1Mb 10ms DropTail
$ns duplex-link $n5 $n1 1Mb 10ms DropTail
$ns duplex-link $n6 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

$ns duplex-link $n2 $n7 1Mb 10ms DropTail
$ns duplex-link $n2 $n8 1Mb 10ms DropTail
$ns duplex-link $n2 $n9 1Mb 10ms DropTail
$ns duplex-link $n2 $n10 1Mb 10ms DropTail
$ns duplex-link $n8 $n9 1Mb 10ms DropTail

#n1 to n4 udp
set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null0 [new Agent/UDP]
$ns attach-agent $n4 $null0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 800 $cbr0
set interval_ 0.008
$cbr0 attach-agent $udp0
$ns connect $udp0 $null0

#n1 to n3 udp
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null1 [new Agent/UDP]
$ns attach-agent $n3 $null1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 800 $cbr1
set interval_ 0.008
$cbr1 attach-agent $udp1
$ns connect $udp1 $null1

#n1 to n5 udp
set udp2 [new Agent/UDP]
$ns attach-agent $n1 $udp2
set null2 [new Agent/UDP]
$ns attach-agent $n5 $null2
set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 800 $cbr2
set interval_ 0.008
$cbr2 attach-agent $udp2
$ns connect $udp2 $null2

#n1 to n6 udp
set udp3 [new Agent/UDP]
$ns attach-agent $n1 $udp3
set null3 [new Agent/UDP]
$ns attach-agent $n6 $null3
set cbr3 [new Application/Traffic/CBR]
$cbr3 set packetSize_ 800 $cbr3
set interval_ 0.008
$cbr3 attach-agent $udp3
$ns connect $udp3 $null3

#n2 to n7 udp
set udp4 [new Agent/UDP]
$ns attach-agent $n2 $udp4
set null4 [new Agent/UDP]
$ns attach-agent $n7 $null4
set cbr4 [new Application/Traffic/CBR]
$cbr4 set packetSize_ 800 $cbr4
set interval_ 0.008
$cbr4 attach-agent $udp4
$ns connect $udp4 $null4

#n2 to n8 udp
set udp5 [new Agent/UDP]
$ns attach-agent $n2 $udp5
set null5 [new Agent/UDP]
$ns attach-agent $n8 $null5
set cbr5 [new Application/Traffic/CBR]
$cbr5 set packetSize_ 800 $cbr5
set interval_ 0.008
$cbr5 attach-agent $udp5
$ns connect $udp5 $null5

#n2 to n9 udp
set udp6 [new Agent/UDP]
$ns attach-agent $n2 $udp6
set null6 [new Agent/UDP]
$ns attach-agent $n9 $null6
set cbr6 [new Application/Traffic/CBR]
$cbr6 set packetSize_ 800 $cbr6
set interval_ 0.008
$cbr6 attach-agent $udp6
$ns connect $udp6 $null6

#n2 to n10 udp
set udp7 [new Agent/UDP]
$ns attach-agent $n2 $udp7
set null7 [new Agent/UDP]
$ns attach-agent $n10 $null7
set cbr7 [new Application/Traffic/CBR]
$cbr7 set packetSize_ 800 $cbr7
set interval_ 0.008
$cbr7 attach-agent $udp7
$ns connect $udp7 $null7

#n8 to n9 udp
set udp8 [new Agent/UDP]
$ns attach-agent $n8 $udp8
set null8 [new Agent/UDP]
$ns attach-agent $n9 $null8
set cbr8 [new Application/Traffic/CBR]
$cbr8 set packetSize_ 800 $cbr8
set interval_ 0.008
$cbr8 attach-agent $udp8
$ns connect $udp8 $null8



#n1 to n2 tcp flow

set tcp [new Agent/TCP]

$tcp set class_ 2
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP


$udp0 set fid_ 1
$udp1 set fid_ 1
$udp2 set fid_ 1
$udp3 set fid_ 1
$udp4 set fid_ 1
$udp5 set fid_ 1
$udp6 set fid_ 1
$udp7 set fid_ 1
$udp8 set fid_ 1



$tcp set fid_ 2

$ns at 1.0 "$cbr0 start"
$ns at 1.5 "$cbr1 start"
$ns at 2.0 "$cbr2 start"
$ns at 2.5 "$cbr3 start"
$ns at 3.0 "$cbr4 start"
$ns at 3.5 "$cbr5 start"
$ns at 4.0 "$cbr6 start"
$ns at 4.5 "$cbr7 start"
$ns at 5.0 "$cbr8 start"

$ns at 3.0 "$ftp start"

$ns at 6.0 "$cbr0 stop"
$ns at 6.5 "$cbr1 stop"
$ns at 7.0 "$cbr2 stop"
$ns at 7.5 "$cbr3 stop"
$ns at 8.5 "$cbr4 stop"
$ns at 9.0 "$cbr5 stop"
$ns at 9.5 "$cbr6 stop"
$ns at 10.0 "$cbr7 stop"
$ns at 10.5 "$cbr8 stop"

$ns at 11.0 "$ftp stop"
$ns at 12.0 "finish"

$ns run
