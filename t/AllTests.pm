package AllTests;
use base qw(Test::Unit::TestSuite);
use User;

sub include_tests {
    qw(BasicUserTests)
}
1;