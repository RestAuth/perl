package AllTests;
use base qw(Test::Unit::TestSuite);
use User;

sub include_tests {
    qw(UserList UserCreate UserExists UserVerifyPassword UserSetPassword UserRemove)
}
1;