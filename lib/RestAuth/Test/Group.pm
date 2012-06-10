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

=head3 RestAuth::Test::User::List
Test listing users.
=cut
package RestAuth::Test::Group::Initial;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

#use RestAuth::User;
use RestAuth::Group;

sub test_whatever : Test(1) {
    my $self = shift;
    my $group = RestAuth::Group->new($self->{conn}, 'groupname');
    
    my %query = ('foo' => 'bar bar');
    
    $group->request_get('', \%query);
}

1;