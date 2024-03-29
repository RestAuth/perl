# This file is part of RestAuth.pm.
#
# RestAuth.pm is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RestAuth.pm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with RestAuth.pm.  If not, see <http://www.gnu.org/licenses/>.

=head1 NAME

RestAuth::Test - Base class for common test functionality.

=head1 DESCRIPTION

Baseclass for all testcases

=head1 METHODS

=cut
package RestAuth::Test;
use strict;
use warnings;

use Test::More;
use Test::Deep;

use base qw(Test::Class);

use RestAuth::Connection;
use RestAuth::User;
use RestAuth::Group;

=head2 make_fixture

Run at the start of every test.

=cut
sub make_fixture : Test(setup) {
    my $self = shift;
    $self->{conn} = new RestAuth::Connection('http://[::1]:8000', 'example.com', 'example');
    
    my @users = RestAuth::User->get_all($self->{conn});
    for my $user (@users) {
        $user->remove();
    }
    
    my @groups = RestAuth::Group->get_all($self->{conn});
    for my $group (@groups) {
        $group->remove();
    }
};

=head2 is_resource($got, $expected, $testname=undef)

Test if two resources represent essentially the same resource.

=cut
sub is_resource {
    my ($self, $expected, $got, $testname) = @_;
    
    $testname = 'Resources are equal' if not defined $testname;
    
    subtest $testname => sub {
        isa_ok($got, ref($expected), '$excepted');
        is($expected->{_name}, $got->{_name}, 'Name of resource');
        is($expected->{_conn}->{_url}, $got->{_conn}->{_url}, 'Connection URL');
        is($expected->{_conn}->{_auth_header},
           $got->{_conn}->{_auth_header}, 'Connection credentials');
    }
}

=head2 resources_ok($class, \@got, \@expected, $testname)

Check that \@got and \@expected contain exactly the same resources.

=cut
sub resources_ok {
    my ($self, $class, $got, $expected, $testname) = @_;
    $testname = 'Check for equal resources' if not defined $testname;
    
    subtest $testname => sub {
        cmp_deeply(\@{$got}, array_each(isa($class)), 'Check type of received elements.');
        cmp_deeply(\@{$expected}, array_each(isa($class)), 'Check type of expected elements');
        
        is(scalar(@{$expected}), scalar(@{$got}), 'Lists are of equal length');
        cmp_bag($got, $expected, 'Deep comparison of elements');
    };
}

1;