set ns [new Simulator]
$ns color 1 Blue
$ns color 2 Red

set nf [open sim.nam w]
set nt [open fourth.tr w]

$ns namtrace-all $nf
$ns trace-all $nt

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$n0 color red
$n1 color red
$n2 color brown

$ns duplex-link $n0 $n2 2Mb 8ms DropTail
$ns duplex-link $n1 $n2 1Mb 8ms DropTail
$ns duplex-link $n2 $n3 2Mb 8ms DropTail

$ns queue-limit $n0 $n2 3
$ns queue-limit $n1 $n2 3

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

$ns connect $tcp $sink

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null

$ns connect $udp $null

$tcp set fid_ 1
$udp set fid_ 2

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set cbr [new Application/Traffic/CBR]

$cbr attach-agent $udp

proc finish {} {
	global ns nf nt
	$ns flush-trace
	close $nf
	close $nt
	exec nam sim.nam &
	exit 0
}

$ns at 0.1ms "$ftp start"
$ns at 0.1ms "$cbr start"
$ns at 4ms "finish"
$ns run
