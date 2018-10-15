#!/usr/bin/perl
use strict; use warnings;

open(IN, '< bacteria_accs.txt');

my @accs;

while(<IN>){
    my $line=$_;
    chomp($line);
    push @accs,$line;
}

close IN;

open(IN2, '< run_and_exptid.txt');

my %expts;
while(<IN2>){
    my $line=$_;
    chomp($line);
    my($a,$b)=split('\t',$line);
    $expts{$a}=$b;
}

foreach my $acc (@accs){
    print $acc,"\t",$expts{$acc},"\n";
}

close IN2;

