use strict;
use warnings;
use 5.010;

use List::Util qw/shuffle/;

my @teams = qw/A B C D E F/;

my @games;

while ( @teams > 1 ) {
   my $first = shift @teams;
   push @games, [$first,$_] for @teams;
}

say join(" vs ", @$_) for shuffle @games;
