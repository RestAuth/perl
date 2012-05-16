package BaseTest;
use base qw(Test::Unit::TestCase);
use RestAuthConnection;

sub set_up {
    my $self = shift;
    $self->{conn} = new RestAuthConnection('http://[::1]:8000', 'example.com', 'example');
}
1;