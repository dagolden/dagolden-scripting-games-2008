use strict;
use warnings;
use 5.010;

use List::Util qw/first/;

my @primes = '2';

for my $n ( 3 .. 200 ) {
    push @primes, $n if ! first { $n % $_ == 0 } @primes;
}

say for @primes;
