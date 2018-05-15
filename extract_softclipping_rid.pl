#!/usr/bin/perl

use strict;
use warnings;
(my $usage = <<OUT) =~ s/\t+//g;
perl extract_disc_reads.pl f_in chr pos
OUT

die $usage unless @ARGV == 3;
my ($f_bam,$chr,$pos) = @ARGV;

#my $f_out=$f_bam.".".$chr."_".$pos.".sam";

my $bam_n=(split(/\//,$f_bam))[-1];

my $f_fa=$bam_n.".".$chr."_".$pos.".softclipping.rid";

my $left_pos=$pos-10;
my $right_pos=$pos+10;
my %inf_rid=(); 

my $chr_pos=$chr.":".$left_pos."-".$right_pos;
#open(OUT,">$f_out"); 
open(FA,">$f_fa"); 

if($f_bam ne "NULL" && (-e $f_bam))
        {
			my $rid; 
#			foreach my $t (`samtools view $f_bam $chr_pos`)

            foreach my $t (`samtools view $f_bam \"$chr_pos\"`)
			{
				chomp($t); 
				my @temp=split("\t",$t);
                my $id=$temp[0];   
				my $flag=$temp[1];
				my $cigar=$temp[5];   
			 	my $start_pos=$temp[3]; 
				my $find_reads=0;
				if($cigar=~/(\d+)M(\d+)S/) {
				my $m=$1; 
				if(abs($start_pos+$m-1-$pos)<=2)
					{
					$find_reads=1; 
					}	
				}

				if(abs($start_pos-$pos)<=2 && $cigar=~/\d+S\d+M/)			
				{
					$find_reads=1; 
				}

 				if($cigar=~/(\d+)M(\d+)I(\d+)M(\d+)S/)
                                {
                                        my $m=$1+$3;
                                        if(abs($start_pos+$m-1-$pos)<=2)
                                        {
                                        $find_reads=1;
                                        }
                                }

				if($find_reads ==1) 
				{
					#if($id=~/\/2$/ || ($flag & 0x80)) 
					#{ 
					$rid=$id; $rid=~s/\/2$//g;
       			    $rid=~s/\/1$//g; 
		            #$rid.="\/2"; 
					#print OUT $t,"\n";
					#print FA ">$rid","\n";	
					#print FA $temp[9],"\n";	
					$inf_rid{$rid}=1; 
				}	
              }
			}			
		
foreach my $r (sort keys %inf_rid) 
	{
		print FA $r,"\n" 
	}

close FA; 

#	close FA; 
	
				
