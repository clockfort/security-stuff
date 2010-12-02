
#!/usr/bin/perl -w

# $Id: ios7decrypt.pl,v 1.1 1998/01/11 21:31:12 mesrik Exp $

#

# Credits for original code and description hobbit@avian.org,

# SPHiXe, .mudge et al. and for John Bashinski 

# for Cisco IOS password encryption facts.

#

# Use of this code for any malicious or illegal purposes is strictly prohibited!

#

@xlat = ( 0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f, 0x41,
          0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72, 0x6b, 0x6c,
          0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53 , 0x55, 0x42 );

while (<>) {

        if (/(password|md5)\s+7\s+([\da-f]+)/io) {

            if (!(length($2) & 1)) {

                $ep = $2; $dp = "";

                ($s, $e) = ($2 =~ /^(..)(.+)/o);

                for ($i = 0; $i < length($e); $i+=2) {

                    $dp .= sprintf "%c",hex(substr($e,$i,2))^$xlat[$s++];

                }

                s/7\s+$ep/$dp/;

            }

        }

        print;
