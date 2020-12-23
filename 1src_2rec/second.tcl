set ns [new Simulator]


set nf [open sim.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]



$ns duplex-link $n0 $n1 1Mb 2ms DropTail
$ns duplex-link $n0 $n2 1Mb 2ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1


set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1

set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $sink2

$ns connect $tcp $sink1

$ns connect $tcp1 $sink2


set ftp [new Application/FTP]
$ftp attach-agent $tcp

set ftp1 [new Application/FTP]
$ftp1	 attach-agent $tcp1

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam sim.nam &
	exit 0
	}
	
$ns at 0.1ms "$ftp start"
$ns at 0.1ms "$ftp1 start"

$ns at 4ms finish

$ns run
