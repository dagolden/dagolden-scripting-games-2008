use strict;
use warnings;
use 5.010;

my $password = shift @ARGV or die "Usage: $0 <password>\n";
my $score = 13;

# build wordlist in memory

my %wordlist;
open my $dict, 'C:\Scripts\wordlist.txt' or die $!;
while ( my $line = <$dict> ) { 
    chomp $line;
    $wordlist{ lc $line }++;
}

# Make sure that the password is not an actual word. The password rhubarb
# fails this test because rhubarb is an actual word. To determine whether a
# word is an actual word or not, always use the file WordList.txt, an
# official word list that is included as part of the Scripting Games
# Competitors’ Pack. (Make sure you put this file in the folder C:\Scripts.)
# Note that this check should be case-insensitive: not only is rhubarb an
# actual word but so is RHUBARB, rhUBArb, etc.

if ( $wordlist{ lc $password } ) { 
    say "Password is an actual word";
    $score--; 
}
	
# Make sure that the password, minus the last letter, is not an actual
# word.  For example, the password rhubarb5 fails this test because, if you
# remove the last letter, the remaining string value – rhubarb – is an actual
# word. This check should be case-insensitive.

if ( $wordlist{ lc substr($password,0,-1) } ) { 
    say "Password, minus last letter, is an actual word";
    $score--; 
}
	
# Make sure that the password, minus the first letter, is not an actual word.
# For example, the password @rhubarb fails this test because, if you remove
# the first letter, the remaining string value – rhubarb – is an actual word.
# This check should be case-insensitive.

if ( $wordlist{ lc substr($password,1) } ) { 
    say "Password, minus first letter, is an actual word";
    $score--; 
}
	
# Make sure that the password does not simply substitute 0 (zero) for the
# letter o (either an uppercase O or a lowercase o). For example, the
# password t00lb0x fails this test. Why? Because if you replace each of the
# zeroes with the letter O you’ll be left with an actual word: toolbox.

my $convert_zero = $password;
my $found_zero = $convert_zero =~ tr[0][o];
if ( $found_zero && $wordlist{ lc $convert_zero } ) {
    say "Password is an actual word when '0' (zero) replaced with letter 'o'";
    $score--; 
}

# Make sure that the password does not simply substitute 1 (one) for the
# letter l (either an uppercase L or a lowercase l). For example, the
# password f1oti11a fails this test. Why? Because if you replace each of the
# ones with the letter L you’ll be left with an actual word: flotilla.

my $convert_one = $password;
my $found_one = $convert_one =~ tr[1][l];
if ( $found_one && $wordlist{ lc $convert_one } ) {
    say "Password is an actual word when '1' replaced with letter 'l'";
    $score--; 
}

# Make sure that the password is at least 10 characters long but no more than
# 20 characters long. The password rhubarb fails this test because it has
# only 7 characters.

if ( length($password) < 10 || length($password) > 20 ) {
    say "Password has less than 10 or more than 20 characters";
    $score--; 
}

# Make sure that the password includes at least one number (the digits 0
# through 9). The password rhubarb%$qwC fails this test because it does
# not include a number.

if ( $password !~ /\d/ ) {
    say "Password does not contain at least one number ( digits 0 to 9 )";
    $score--; 
}

# Make sure that the password includes at least one uppercase letter. The
# password rhubarb fails this test because it does not have an uppercase
# letter.

if ( $password !~ /[A-Z]/ ) {
    say "Password does not contain at least one uppercase letter";
    $score--; 
}

# Make sure that the password includes at least one lowercase letter. The
# password RHUBARB fails this test because it does not have a lowercase
# letter.

if ( $password !~ /[a-z]/ ) {
    say "Password does not contain at least one lowercase letter";
    $score--; 
}

# Make sure that the password includes at least one symbol. This can be any
# character that is neither an uppercase or lowercase letter, or a number;
# that would include – but not be limited to – the symbols ~, @, #, $, % and
# ^.

if ( $password !~ /[^a-zA-Z0-9]/ ) {
    say "Password does not contain at least one symbol character";
    $score--; 
}

# Make sure that the password does not include four (or more) lowercase
# letters in succession. The password rhubARB fails this test because it
# includes four lowercase letters (rhub) in succession.

if ( $password =~ /[a-z]{4}/ ) {
    say "Password four or more lowercase letters in succession";
    $score--; 
}

# Make sure that the password does not include four (or more) uppercase
# letters in succession. The password rHUBArb fails this test because it
# includes four uppercase letters (HUBA) in succession.

if ( $password =~ /[A-Z]{4}/ ) {
    say "Password has four or more uppercase letters in succession";
    $score--; 
}

# Make sure that the password does not include any duplicate characters. The
# password rhubarb fails this test because it has two r’s and two b’s. This
# check should be case-sensitive: A and a are to be considered separated
# letters. Thus the password Oboe would not fail this particular test.

my $sorted_chars = join( q{}, sort split //, $password );
if ( $sorted_chars =~ /(.)\1/ ) {
    say "Password has duplicate characters";
    $score--; 
}

# convert numerical score to qualitative adjective

my %grade;
@grade{0 .. 6}  = ('weak') x 7;
@grade{7 .. 10} = ('moderately-strong') x 4;
@grade{11 .. 13} = ('strong') x 3;

say "\nA password score of $score indicates a $grade{$score} password";

