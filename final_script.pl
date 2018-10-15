#!/usr/bin/perl

use strict;use warnings;

open(IN, '< bacteria_run_exptid.txt');

my @accs;
my @expts;
my %expthash;

while(<IN>){
    my $line = $_;
    chomp($line);
    my($a,$b)=split('\t',$line);
    push @accs,$a;
    push @expts,$b;
    $expthash{$a}=$b;
}

close IN;

my %hash2;

open(EXP, '< EXPT_INFO.txt');

while(<EXP>){
    my $line = $_;
    chomp $line;
    my($a,$b)=split('\t',$line,2);
    $hash2{$a}=$b;
}
close EXP;

open(BAC, '< SRA_bacteria.txt');

my %hash3;
while(<BAC>){
    my $line=$_;
    chomp $line;
    my($a,$b)=split('\t',$line,2);
    $hash3{$a}=$b;
}

close BAC;
print "ACCESSION\tEXPERIMENT\tDESIGN\tLENGTH\tINSTRUMENT\tBIOSAMPLE\tTAXID\tGENOME_ACCESSION\tSPECIES\n";

foreach my $acc (@accs){
    my $expt = $expthash{$acc};
    if(defined $hash2{$expt}){
	my $bactinfo = $hash3{$acc};
	my $runinfo = $hash2{$expt};
	print $acc,"\t",$expt,"\t",$runinfo,"\t",$bactinfo,"\n";
    }
}

    
