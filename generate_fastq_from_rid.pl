

#!/usr/bin/perl

use strict;
use warnings;
(my $usage = <<OUT) =~ s/\t+//g;
perl generate_fastq_from_rid.pl f_bam s_n f_rid dir_out
OUT

die $usage unless @ARGV == 4;

my ($f_sorted_bam,$s_n,$f_rid,$dir_out) = @ARGV;

#my $bam_n=(split(/\//,$f_bam))[-1];
#my $f_bam_2=$f_bam; 
#$f_bam_2=~s/\.bam$//g; 

my %rid=(); 

#my $f_sorted_bam=$f_bam_2.".sorted.bam";

my $f_q1=$dir_out."/".$s_n.".scdisc.fq1";
my $f_q2=$dir_out."/".$s_n.".scdisc.fq2"; 

`rm $f_q1`; 
`rm $f_q2`; 

#`samtools sort -n $f_bam $f_sorted_bam`;

foreach my $l (`cat $f_rid`) 
{
	my $ltr=$l; 
	chomp($ltr); 
	$rid{$ltr}=1; 	
}

open(OUT1,">$f_q1"); 
open(OUT2,">$f_q2");  

my $r1="";
my $r2="";
my $seq1; 
my $q1;
my $seq2; 
my $q2;

open IN,"samtools view $f_sorted_bam |";
while (<IN>)
	{
	my $t=$_; 
	my $ttr=$t; 
	chomp($ttr); 

	my @ss=split("\t",$ttr); 
	my $flag=$ss[1]; 
	my $cigar=$ss[5];
 	my $id=$ss[0]; 
	my $seq=$ss[9]; 
	my $q=$ss[10];
	#my $seq1; 
	#my $seq2; 
	#my $q1; 
	#my $q2; 
	#my $r1=""; 
	#my $r2=""; 
	#print $flag,"\n"; 
	#<STDIN>;
	if(($flag & 0x100) || ($flag & 0x800) || ($cigar=~/H/)) 
	{ next; }

	if($id=~/\/1$/ || ($flag & 0x40) ) 
	{ 
	   $r1=$id; $r1=~s/\/1$//g; 
	   $seq1=$seq; $q1=$q; 
   	} 
 	
	
	if($id=~/\/2$/ || ($flag & 0x80)) 
	{ $r2=$id; $r2=~s/\/2$//g; $seq2=$seq; $q2=$q; } 
	#print $id,"\n";
	#print $r1,"\t",$r2,"\n";
	#<STDIN>;	
	if(($r1 eq $r2 && defined $rid{$r1})) 
	{ 

      	  print OUT1 "@",$r1,"/1","\n"; 
	  print OUT1 $seq1,"\n"; 
	  print OUT1 "+","\n"; 
	  print OUT1 $q1,"\n"; 
	  print OUT2 "@",$r1,"/2","\n"; 
	  print OUT2 $seq2,"\n"; 
	  print OUT2 "+","\n"; 
      	  print OUT2 $q2,"\n";

  	}
		
}

