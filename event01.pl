use strict;
use warnings;
use 5.010;

my @num2chars=split ':', '::abc:def:ghi:jkl:mno:prs:tuv:wxy';
say "Enter a seven-digit phone number:"; 
my $regex = join q{}, map { "[$num2chars[$_]]" } split //, <STDIN>, 7;
open my $dict, 'C:\Scripts\wordlist.txt' or die $!;
while ( my $line = uc <$dict> ) { say($line), last if $line =~ /^$regex$/i } 
