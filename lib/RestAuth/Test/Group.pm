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
package RestAuth::Test::Group::Create;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Exception;

use RestAuth::Group;
#use RestAuth::Error::GroupExists;

sub test_create : Test(3) {
    my $self = shift;
    
    throws_ok { RestAuth::Group->get($self->{conn}, 'group name'); }
        'RestAuth::Error::GroupNotFound', 'Group not found yet.';
    my $group = RestAuth::Group->create($self->{conn}, 'group name');
    isa_ok($group, 'RestAuth::Group');
    ok($group->exists());
}

sub test_create_twice : Test(5) {
    my $self = shift;
    
    throws_ok { RestAuth::Group->get($self->{conn}, 'group name'); }
        'RestAuth::Error::GroupNotFound', 'Group not found yet.';
    my $group = RestAuth::Group->create($self->{conn}, 'group name');
    isa_ok($group, 'RestAuth::Group');
    ok($group->exists());
    
    throws_ok { RestAuth::Group->create($self->{conn}, 'group name'); }
        'RestAuth::Error::GroupExists', 'Group already exists.';
    ok($group->exists());
}

sub test_create_short_name : Test(2) {
    my $self = shift;
    
    throws_ok { RestAuth::Group->create($self->{conn}, 'a:b'); }
        'RestAuth::Error::PreconditionFailed', 'Group name contains invalid characters.';
        
    throws_ok { RestAuth::Group->create($self->{conn}, 'a\b'); }
        'RestAuth::Error::PreconditionFailed', 'Group name contains invalid characters.';
}

1;

package RestAuth::Test::Group::Get;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Exception;

use RestAuth::Group;
use RestAuth::Error::GroupNotFound;

sub test_get : Test(1) {
    my $self = shift;
    
    my $group = RestAuth::Group->create($self->{conn}, 'group name');
    my $get = RestAuth::Group->get($self->{conn}, 'group name');
    
    $self->is_resource($group, $get);
}

sub test_get_not_found : Test(1) {
    my $self = shift;
    
    throws_ok { RestAuth::Group->get($self->{conn}, 'groupn ame'); }
        'RestAuth::Error::GroupNotFound', 'Group not found.';
}

1;

package RestAuth::Test::Group::GetAll;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;

use RestAuth::Group;

sub test_none : Test(1){
    my $self = shift;
    
    my @groups = RestAuth::Group->get_all($self->{conn});
    is(0, scalar(@groups));
}

sub test_one : Test(3) {
    my $self = shift;
    
    my $group = RestAuth::Group->create($self->{conn}, 'group name');
    isa_ok($group, 'RestAuth::Group');
    ok($group->exists());
    
    my @expected = ($group);
    
    my @groups = RestAuth::Group->get_all($self->{conn});
    $self->resources_ok('RestAuth::Group', \@groups, \@expected, 'Check groups');
}

sub test_two : Test(5){
    my $self = shift;
    
    my $group = RestAuth::Group->create($self->{conn}, 'group name');
    isa_ok($group, 'RestAuth::Group');
    ok($group->exists());
    
    my $group2 = RestAuth::Group->create($self->{conn}, 'group name2');
    isa_ok($group2, 'RestAuth::Group');
    ok($group2->exists());
    
    my @expected = ($group, $group2);
    
    my @groups = RestAuth::Group->get_all($self->{conn});
    $self->resources_ok('RestAuth::Group', \@groups, \@expected, 'Check groups');
}

1;

package RestAuth::Test::Group::Exists;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

sub test_exists : Test(2) {
    my $self = shift;
    
    my $group = RestAuth::Group->create($self->{conn}, 'group name');
    isa_ok($group, 'RestAuth::Group');
    ok($group->exists());
}

sub test_does_not_exist : Test(2) {
    my $self = shift;
    
    my $group = RestAuth::Group->new($self->{conn}, 'group name');
    isa_ok($group, 'RestAuth::Group');
    ok(! $group->exists());
}

1;

package RestAuth::Test::Group::AddUser;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

1;

package RestAuth::Test::Group::GetUsers;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

1;

package RestAuth::Test::Group::RemoveUser;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

1;

package RestAuth::Test::Group::AddGroup;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

1;

package RestAuth::Test::Group::GetGroups;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

1;

package RestAuth::Test::Group::RemoveUser;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

1;

package RestAuth::Test::Group::GetAllForUser;

use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

1;

package RestAuth::Test::Group::Remove;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Exception;

use RestAuth::Group;

sub test_exists : Test(4) {
    my $self = shift;
    
    my $group = RestAuth::Group->create($self->{conn}, 'group name');
    isa_ok($group, 'RestAuth::Group');
    ok($group->exists());
    
    ok($group->remove());
    ok(! $group->exists());
}

sub test_does_not_exist : Test(3) {
    my $self = shift;
    
    my $group = RestAuth::Group->new($self->{conn}, 'group name');
    isa_ok($group, 'RestAuth::Group');
    ok(! $group->exists());
    
    throws_ok { $group->remove(); }
        'RestAuth::Error::GroupNotFound', 'Group not found.';
}

1;