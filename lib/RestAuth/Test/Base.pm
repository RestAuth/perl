# This file is part of perl-RestAuth.
#
# perl-RestAuth is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# perl-RestAuth is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with perl-RestAuth.  If not, see <http://www.gnu.org/licenses/>.

use Test::More;

sub resources_ok {
    my ($class, $got, $expected, $name) = @_;
    
    subtest 'Check resource equality' => sub {
        cmp_deeply(\@{$got}, array_each(isa($class)), 'Check type of received elements.');
        cmp_deeply(\@{$expected}, array_each(isa($class)), 'Check type of expected elements');
        
        is(scalar(@{$expected}), scalar(@{$got}), 'Lists are of equal length');
        cmp_bag($got, $expected, 'Deep comparison of elements');
    }
}

=head1 RestAuth::Test::Base

Baseclass for all testcases

=cut
package RestAuth::Test::Base;
use strict;
use warnings;

use base qw(Test::Class);

use RestAuth::Connection;
use RestAuth::User;

=head1 make_fixture

Run at the start of every test.

=cut

sub make_fixture : Test(setup) {
    print "\n---\n---\nMAKE FIXTURE\n---\n---\n\n";
    my $self = shift;
    $self->{conn} = new RestAuth::Connection('http://[::1]:8000', 'example.com', 'example');
    
    my @users = RestAuth::User->get_all($self->{conn});
    for my $user (@users) {
        $user->remove();
    }
};

1;

package RestAuth::Test::PropertyBase;
use strict;
use warnings;

use base qw(RestAuth::Test::Base);
use RestAuth::User;

sub make_fixture : Test(setup) {
    my $self = shift;
    $self->SUPER::make_fixture;
    
    $self->{user} = RestAuth::User->create($self->{conn}, 'username');
}

1;
