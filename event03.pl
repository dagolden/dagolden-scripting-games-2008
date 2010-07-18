use strict;
use warnings;
use 5.010;

my @ballots;
open my $fh, 'C:\Scripts\votes.txt' or die $!;
push @ballots, [split /,/] while <$fh>;

my (%votes, $winner);

while ( ! $winner ) {
    for my $b ( @ballots ) {
        $votes{ $b->[0] }++;
    }
    my @results = sort { $votes{$b} <=> $votes{$a} } keys %votes;
    if ( $votes{$results[0]} > int(@ballots / 2) ) { 
        $winner = $results[0]; 
    }
    else { 
        for my $b ( @ballots ) {
            $b = [ grep { $_ ne $results[-1] } @$b ];
        }
        %votes = ();
    }
}

printf "The winner is %s with %d%% of the vote.\n", 
    $winner, int(0.5+100*$votes{$winner}/@ballots);
