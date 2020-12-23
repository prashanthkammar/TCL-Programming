set ns [new Simulator]
$ns color 1 Blue
$ns color 2 Red

set nf [open sim.nam w]
$ns namtrace-all $nf

set tf [open third.tr w]
$ns trace-all $tf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$n1 color red
$n2 color red


$ns duplex-link $n0 $n1 50Mb 1ms DropTail
$ns duplex-link $n0 $n2 50Mb 0.5ms DropTail
$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n0 $n2 orient left-down

#$ns duplex-link-op $n0 $n1 queuePos 0.5
#$ns duplex-link-op $n0 $n2 queuePos 0.5

$ns queue-limit $n1 $n0 3
$ns queue-limit $n2 $n0 3

set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp
set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1


set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1
set sink2 [new Agent/TCPSink]
$ns attach-agent $n0 $sink2

$ns connect $tcp $sink1
$ns connect $tcp1 $sink2

$tcp set fid_ 1
$tcp1 set fid_ 2

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

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
