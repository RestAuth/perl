#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'RestAuth::Connection' ) || print "Bail out!\n";
    use_ok( 'RestAuth::ContentHandler' ) || print "Bail out!\n";
    use_ok( 'RestAuth::Resource' ) || print "Bail out!\n";
    use_ok( 'RestAuth::User' ) || print "Bail out!\n";
    use_ok( 'RestAuth::Group' ) || print "Bail out!\n";
}

diag( "Testing RestAuth $RestAuth::VERSION, Perl $], $^X" );
