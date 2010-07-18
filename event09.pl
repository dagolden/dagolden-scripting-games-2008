use strict;
use warnings;
use 5.010;

open my $fh, 'C:\Scripts\alice.txt' or die $!;
say join q{ }, map { scalar reverse } split q{ }, scalar <$fh>;

