use strict;
use warnings;
use 5.010;

use Date::Calc qw/Days_in_Month Day_of_Week Month_to_Text/;

say "Enter a numeric month and year (M/YYYY or MM/YYYY):";
my ($month, $year) = split qr{/}, <STDIN>;

# list of days for length of the month
my @days = ( 1 .. Days_in_Month($year, $month) );

# pad first week if not starting on Sunday
my $weekday = Day_of_Week($year, $month, 1);
unshift @days, ("") x $weekday if $weekday != 7;

# pad last week if not a full week
push @days, ("") x (7 - @days % 7) if @days % 7 != 0; 

# prepend day headers
unshift @days, qw/Sun Mon Tue Wed Thu Fri Sat/;

# print it all out
printf( "\n%s %d\n\n", Month_to_Text($month), $year );
while ( @days ) {
    printf( '%3s  ' x 7 . "\n", splice @days, 0, 7 );
}
