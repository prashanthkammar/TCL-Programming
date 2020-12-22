BEGIN {udp=0; tcp=0; drop=0}
{
if($1=="r" && $5=="cbr")
{
udp++
}
  else if ($1=="r" && $5=="tcp")
  {
  drop++
  }
}
END{
printf("number of packets sent by tcp = %d \n",tcp);
printf("number of packets sent by udp = %d\n",udp);
printf("number of packets dropped by tcp = %d\n",drop);
}
