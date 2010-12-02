#!/usr/bin/perl
use strict;
use warnings;

#Clockfort 2010

unless(@ARGV) die "Usage: hideuser NAME_OF_USER\n";

my $user = $ARGV[0];
open(REG_FILE, ">temp.reg");
print REG_FILE "REGEDIT4\n\n[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\SpecialAccounts\\UserList]\n";
print REG_FILE "\"$user\"=dword:00000001\n\n";
print "Registry file generated, starting insert...\n";
qx(regedit temp.reg);
print "Deleting temporary registry file...\n";
qx(del temp.reg);
print "...Done.\n";
