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

sub test_create : Test(1) {
    my $self = shift;
    
    my $group = RestAuth::Group->create($self->{conn}, 'groupname');
    ok($group->exists());
}

sub test_create_twice : Test(2) {
    my $self = shift;
    
    my $group = RestAuth::Group->create($self->{conn}, 'groupname');
    ok($group->exists());
    
    throws_ok { RestAuth::Group->create($self->{conn}, 'groupname'); }
        'RestAuth::Error::GroupExists', 'Group already exists.';
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
use Test::Deep;

use RestAuth::Group;

1;

package RestAuth::Test::Group::GetAll;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

1;

package RestAuth::Test::Group::Exists;
use strict;
use warnings;
use RestAuth::Test;
use base qw(RestAuth::Test);

use Test::More;
use Test::Deep;

use RestAuth::Group;

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