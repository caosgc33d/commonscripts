#!/usr/bin/perl
use strict;
use warnings;
my $usage = ' 
perl rc_for_vcf.pl f_vcf f_bam window f_out
';
die $usage unless scalar @ARGV == 4;
my ($f_vcf,$f_bam,$window,$f_out) = @ARGV;

## samtools depth -q 15 -r 10:123241617-123241618 TCGA-02-2483-01A-01D-1494-08.wxs.bam##
open(OUT,">$f_out"); 

foreach my $l (`cat $f_vcf`) 
	{
		my $ltr=$l; 
		chomp($ltr);
		if($ltr=~/^#/) { next; }
		else { 
			my @temp=split("\t",$ltr);
			my $chr=$temp[0]; 
			my $pos_s=$temp[1]-$window; 
			my $pos_e=$temp[1]+$window; 
			my $out_inf=`samtools depth -q 15 -r $chr:$pos_s-$pos_e	$f_bam`;
			print OUT $out_inf;
		}
		
	}

close OUT;

