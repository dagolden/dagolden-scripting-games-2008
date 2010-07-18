use strict;
use warnings;
use 5.010;

use List::Util qw/first shuffle sum/; 

#--------------------------------------------------------------------------#
# Deck is 0 .. 51; Spades are 0 .. 12, then Diamonds, Hearts, Clubs
# Cards 0 .. 12 are 2, 3 .. King, Ace then repeating
#--------------------------------------------------------------------------#

sub new_deck { return [ shuffle (0 .. 51) ] }

my @suits = qw/Clubs Hearts Diamonds Spades/;
my @ranks = 
    qw/Two Three Four Five Six Seven Eight Nine Ten Jack Queen King Ace/;
my @values = (2 .. 10, 10, 10, 10, 11);

# Negative value is a flag for low-ace of value 1 instead of usual
sub rank {  return $ranks [ abs($_[0]) % 13 ] }
sub suit {  return $suits [ abs($_[0]) / 13 ] } # could % 4 for multi-deck :-)
sub value { return $_[0] < 0 ? 1 : $values[ $_[0] % 13 ] } 

# hand valuation recurses if high aces might bring value under 21
sub value_hand {
    my $hand = shift;
    my $sum = sum map { value($_) } @$hand;
    if      ($sum <= 21)                { return $sum }
    elsif   (toggle_high_ace( $hand ))  { return value_hand( $hand ) }
    else                                { return $sum }
}

# convert the *first* high ace in the hand to low; return is true if anything
# was converted
sub toggle_high_ace {
    my $hand = shift;
    local $_;
    for ( @$hand ) {
        if ( $_ > 0 && rank($_) eq 'Ace' ) {
            $_ *= -1;
            return 1;
        }
    }
    return;
}

sub show_hand {
    my ($who, $how_many) = @_;
    my $hand = $who->{hand};
    say "$who->{name} cards:";
    $how_many ||= @$hand;
    for ( 0 .. @$hand -1 ) {
        if ( $_ < $how_many ) {
            say "  ", rank($hand->[$_]), " of ", suit($hand->[$_]);
        }
        else {
            say "  ?? of ??";
        }
    }
    say "\n$who->{name} total is ", value_hand( $hand ) if $how_many == @$hand;
    print "\n";
}

sub player_stays {
    local $| = 1;
    my $h_s;
    do {
        print "Hit (h) or stay (s)? ";
        $h_s = <STDIN> 
    } until $h_s =~ /^[hs]/i;
    print "\n";
    return $h_s =~ /^s/i;
}

sub dealer_stays {
    my ($hand, $target) = @_;
    return value_hand($hand) >= $target;
}

sub play_hand {
    my ($deck, $who, $target) = @_;
    while ( value_hand($who->{hand}) < $target ) {
        show_hand( $who );
        last if $who->{stay_fcn}($who->{hand}, $target);
        push @{$who->{hand}}, shift @$deck;
    }
}

sub main {
    my $deck = new_deck();
    
    my $player = {
        name => "Your", 
        hand => [ splice @$deck, 0, 2 ],
        stay_fcn => \&player_stays,
    };

    my $dealer = {
        name => "Dealer's",
        hand => [ splice @$deck, 0, 2 ],
        stay_fcn => \&dealer_stays,
    };

    show_hand( $dealer, 1 );

    play_hand( $deck, $player, 21 );
    show_hand( $player );
    my $player_total = value_hand( $player->{hand} );

    if ( $player_total > 21 ) {
        say "You go bust and lose!";
    }
    elsif ( $player_total == 21) {
        say "You win!";
    }
    else {
        play_hand($deck, $dealer, $player_total); 
        show_hand( $dealer );
        my $dealer_total = value_hand( $dealer->{hand} );

        if ( $dealer_total > 21 ) {
            say "Dealer busts and you win!";
        }
        elsif ( $player_total > $dealer_total ) {
            say "You beat the dealer and win!";
        }
        elsif ( $player_total == $dealer_total ) {
            say "The dealer wins ties.  You lose!";
        }
        else {
            say "The dealer beats you.  You lose!";
        }
    } 
}

main;
