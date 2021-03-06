#!/usr/bin/perl -w
use strict;
use File::Basename;
die "perl $0 <dir contain repeat stat file of each sample> <outputfile>" unless @ARGV == 2;
my($dir,$out) = @ARGV;
my %hash;
my @files = glob("$dir/*.edit.rep.txt");
foreach my $file(@files)
{
	my $name = basename $file;
	$name =~ s/\.edit\.rep\.txt//;
	open IN,"$file" or die;
	while(<IN>)
	{
		chomp;
		next if(/Iterm/ || /^#/ || /^$/);
		my ($term,$count,$per)=split /\t/,$_;
		$hash{$name}{$term} = "$count\t$per";
	}
	close IN;
}
open OUT,">$out" or die;
my @head = qw(Alu Alu(%) RepNonAlu RepNonAlu(%) NonRep NonRep(%));
my $head = join "\t",@head;
print OUT "Sample\t$head\n";
foreach my $samp(keys %hash)
{
	print OUT "$samp";
	for (my $i=0;$i <= $#head;$i+=2)
	{
		print OUT "\t$hash{$samp}{$head[$i]}";
	}
	print OUT "\n";
}
close OUT;

