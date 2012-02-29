#!/usr/bin/perl
use strict;
local $| = 1;
my $val = 10;
for (my $i=0; $i<$val; $i++) {
    print "$i";
    sleep(1);
}
