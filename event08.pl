use strict;
use warnings;
use 5.010;

my $min_length = 75 * 60;
my $max_length = 80 * 60;

# load up songs -- convert time to total seconds
my @songs;
open my $fh, 'C:\Scripts\songlist.csv' or die $!;
while ( my $line = <$fh> ) {
    chomp $line;
    my ($artist,$title,$min,$sec) = split /[,:]/, $line;
    push @songs, {
        artist => $artist, 
        title => $title, 
        duration => "$min\:$sec", 
        seconds => $min * 60 + $sec 
    };
}

# assign from largest to smallest, skipping artists after 2 songs
my @playlist;
my %artist_count;
my $duration = 0;

for my $s ( sort { $b->{seconds} <=> $a->{seconds} } @songs ) {
    next if $artist_count{$s->{artist}} && $artist_count{$s->{artist}} == 2;
    next if $duration + $s->{seconds} > $max_length;
    push @playlist, $s;
    $artist_count{ $s->{artist} }++;
    $duration += $s->{seconds};
    last if $duration > $min_length;
}

for my $track ( sort { $a->{artist} cmp $b->{artist} } @playlist ) {
    say join "   ", $track->{artist}, $track->{title}, $track->{duration};
}
say "\nDuration: " . int( $duration / 60 ) . ":" . $duration % 60; 

