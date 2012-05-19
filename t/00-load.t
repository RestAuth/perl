#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'RestAuth' ) || print "Bail out!\n";
}

diag( "Testing RestAuth $RestAuth::VERSION, Perl $], $^X" );
