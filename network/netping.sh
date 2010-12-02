#!/bin/sh
for i in {1..254}
do
	arping -c 1 192.168.1.$i | grep reply &
done
