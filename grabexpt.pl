#!/usr/bin/perl
use strict; use warnings;

open(TMP, "< tmp");
open(TMP2, "< tmp2");
my @tmp2;
my %tmp3;

while(<TMP2>){
    my $a = $_;
    chomp($a);
    push @tmp2,$a;
}

close TMP2;

while(<TMP>){
    my $a = $_;
    chomp($a);
    my($b,$c) = split(/\t/,$a);
    $tmp3{$b}=$c;
}
close TMP;

foreach my $x (@tmp2){
    print $tmp3{$x},"\n";
}
