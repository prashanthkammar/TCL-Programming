set ns [new Simulator]
$ns color 1 Red

set nf [open sim.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$n0 color red
$n1 color blue

$ns duplex-link $n0 $n1 2Mb 4ms DropTail
$ns duplex-link $n1 $n2 2Mb 4ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam sim.nam &
	exit 0
	}
	
$ns at 0.1ms "$ftp start"
$ns at 4ms "finish"

$ns run
