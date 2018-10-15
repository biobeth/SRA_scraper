#!/usr/bin/perl

use strict;

open(IN,"< biosample_taxid.txt");
my %sampleid;
while(<IN>){
    my $line = $_;
    chomp($line);
    my($a, $b) = split(/\t/, $line);
    $sampleid{$a}=$b;
}

close IN;

open(IN,"< SRA_with_biosample.txt");
my %srasample;
my @sra;

while(<IN>){
    my $line= $_;
    chomp($line);
    my($a,$b)= split(/\t/,$line);
    $srasample{$a}=$b;
    push @sra, $a;    
}

close IN;


open(IN,"< acc_taxid_name_assemblylevel.txt");

my %info;
    
while(<IN>){
    my $line= $_;
    chomp($line);
    my($a,$b,$c,$d)= split(/\t/,$line);
    my $e=join "\t",$a,$c,$d;
    $info{$b}=$e;
}

close IN;


#print $srasample{"SRR1185412"},"\n";
#print $sampleid{"SAMN02677407"},"\n";
#print $info{'331111'},"\n";


foreach my $acc (@sra){
    my $sample = $srasample{$acc};
    my $taxid = $sampleid{$sample};
    if (defined $info{$taxid}){
	my $deets= $info{$taxid};
	print $acc,"\t",$sample,"\t",$taxid,"\t",$deets,"\n";
    }
}
