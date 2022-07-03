use strict;
#use warnings;

my %hash=();
open(RF,"intersectGenes.txt") or die $!;
while(my $line=<RF>){
	next if($.==1);
	chomp($line);
	my @arr=split(/\t/,$line);
	if($arr[1]>0){
		$hash{$arr[0]}="up";
	}else{
		$hash{$arr[0]}="down";
	}
}
close(RF);

my %repHash=();
open(RF,"string_interactions.tsv") or die $!;
open(NET,">network.txt") or die $!;
print NET "Node1\tNode2\tPPI\n";
open(NODE,">node.txt") or die $!;
print NODE "Gene\tType\n";

while(my $line=<RF>){
	
	next if($.==1);
	chomp($line);
	my @arr=split(/\t/,$line);
	if( (exists $hash{$arr[0]}) && (exists $hash{$arr[1]}) ){
		unless(exists $repHash{"$arr[0]\t$arr[1]"}){
			print NET "$arr[0]\t$arr[1]\tppi\n";
			$repHash{"$arr[0]\t$arr[1]"}=1;
			$repHash{"$arr[1]\t$arr[0]"}=1;
		}
		unless(exists $repHash{$arr[0]}){
			print NODE "$arr[0]\t$hash{$arr[0]}\n";
			$repHash{$arr[0]}=1;
		}
		unless(exists $repHash{$arr[1]}){
			print NODE "$arr[1]\t$hash{$arr[1]}\n";
			$repHash{$arr[1]}=1;
		}
	}
}
close(NODE);
close(NET);
close(RF);