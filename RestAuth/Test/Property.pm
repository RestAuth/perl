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

package RestAuth::Test::Property::GetAll;
use RestAuth::Test::Base;
use base qw(RestAuth::Test::PropertyBase);
use Test::More;

sub test_no_properties : Test(1) {
    my $self = shift;
    
    my %props = $self->{user}->get_properties;
    is(scalar(%props), 0, "New user has no properties");
}

sub test_one_property : Test {
    
}

sub test_two_properties : Test {
    
}

sub test_user_doesnt_exist : Test {
    
}
1;

package RestAuth::Test::Property::Create;
use base qw(RestAuth::Test::PropertyBase);
use Test::More;

sub test_create : Test {}
sub test_create_conflict : Test {}
sub test_create_user_doesnt_exist : Test {}

1;

package RestAuth::Test::Property::Get;
use base qw(RestAuth::Test::PropertyBase);
use Test::More;

sub test_get : Test {}
sub test_user_doesnt_exist : Test {}
sub test_prop_doesnt_exist : Test {}

1;

package RestAuth::Test::Property::Set;
use base qw(RestAuth::Test::PropertyBase);
use Test::More;

sub test_create : Test {}
sub test_update : Test {}
sub test_user_doesnt_exist : Test {}

1;

package RestAuth::Test::Property::Delete;
use base qw(RestAuth::Test::PropertyBase);
use Test::More;

sub test_delete : Test {}
sub test_user_doesnt_exist : Test {}

1;