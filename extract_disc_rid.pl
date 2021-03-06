#!/usr/bin/perl

use strict;
use warnings;
(my $usage = <<OUT) =~ s/\t+//g;
perl extract_disc_reads.pl f_in sn chr pos dir_out
OUT

die $usage unless @ARGV == 5;
my ($f_bam,$sn,$chr,$pos,$dir_out) = @ARGV;

#my $f_out=$f_bam.".".$chr."_".$pos.".sam";
#my $bam_n=(split(/\//,$f_bam))[-1];

my $f_fa=$dir_out."/".$sn.".".$chr."_".$pos.".disc.rid";

my $left_pos=$pos-1000;
my $right_pos=$pos+1000;

my $chr_pos=$chr.":".$left_pos."-".$right_pos;
my %inf_rid=();
open(FA,">$f_fa"); 

if($f_bam ne "NULL" && (-e $f_bam))
        {
			my $rid; 
            foreach my $t (`samtools view $f_bam \"$chr_pos\"`)
            {
                chomp($t);
				my @temp=split("\t",$t);
				my $id=$temp[0];
				$rid=$id; $rid=~s/\/2$//g;
				$rid=~s/\/1$//g;
                $inf_rid{$rid}=1;
                }
              }

foreach my $r (sort keys %inf_rid)
    {
        print FA $r,"\n"
    }
            

	close FA; 
	
				
