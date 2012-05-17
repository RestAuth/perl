package BaseTest;
use strict;
use warnings;

use base qw(Test::Unit::TestCase);
use Scalar::Util qw(blessed);
use List::Compare;

use RestAuth::Connection;

sub set_up {
    my $self = shift;
    $self->{conn} = new RestAuth::Connection('http://[::1]:8000', 'example.com', 'example');
    
    my @users = RestAuth::User->get_all($self->{conn});
    for my $user (@users) {
        $user->remove();
    }
}

sub assert_equal_resources {
    my ($self, $expected, $actual) = @_;
    
    # assert equal number of objects:
    my $expected_num = scalar(@{$expected});
    my $actual_num = scalar(@{$actual});
    $self->assert_num_equals($expected_num, $actual_num,
                            "Incorrect number of resources!");
    if ($expected_num == 0) {
        return 1;
    }
    
    # check that all are of the same type:
    my @types = ();
    my @expected_names = ();
    my @actual_names = ();
    for my $resource (@{$expected}) {
        my $type = blessed $resource;
        $self->assert_not_null($type);
        push(@types, $type) if ! grep {$_ eq $type} @types;
        push(@expected_names, $resource->{_name});
    }
    for my $resource (@{$actual}) {
        my $type = blessed $resource;
        $self->assert_not_null($type);
        push(@types, $type) if ! grep {$_ eq $type} @types;
        push(@actual_names, $resource->{_name});
    }
    $self->assert_num_equals(1, scalar(@types));
    
    # check that names are the same:
    my $lc = List::Compare->new(\@expected_names, \@actual_names);
    $self->assert($lc->is_LequivalentR(), "Names of resources are not equal!");
}
1;