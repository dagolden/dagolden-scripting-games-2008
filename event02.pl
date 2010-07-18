use strict;
use warnings;
use 5.010;

my %skaters;
open my $scores, 'C:\Scripts\skaters.txt' or die $!;
while ( defined( my $line = <$scores>)  ) { 
    my ($name, @scores) = split /,/, $line;
    my @sorted = (sort @scores)[1 .. $#scores-1];
    my $sum = 0; $sum += $_ for @sorted;
    $skaters{$name} = $sum / @sorted;
}

my @winners = sort { $skaters{$b} <=> $skaters{$a} } keys %skaters;
my @colors = qw/Gold Silver Bronze/;

for ( 0 .. 2 ) {
    printf "%s medal: %s, %.4f\n", 
        $colors[$_], $winners[$_], $skaters{$winners[$_]};
}

