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
use Test::Exception;

sub test_no_properties : Test(1) {
    my $self = shift;
    
    my %props = $self->{user}->get_properties;
    is(scalar(%props), 0, "New user has no properties");
}

sub test_one_property : Test(3) {
    my $self = shift;
    
    ok($self->{user}->create_property('email', 'mati@restauth.net'), 'Set property');
    
    my %props = $self->{user}->get_properties;
    is(scalar(keys %props), 1, "User has one property");
    is($props{'email'}, 'mati@restauth.net', 'Check value of property');
}

sub test_two_properties : Test(5) {
    my $self = shift;
    
    ok($self->{user}->create_property('email', 'mati@restauth.net'), 'Set property 1');
    ok($self->{user}->create_property('first name', 'mati'), 'Set property 2');
    
    my %props = $self->{user}->get_properties;
    is(scalar(keys %props), 2, "User has one property");
    is($props{'email'}, 'mati@restauth.net', 'Check value of 1st property');
    is($props{'first name'}, 'mati', 'Check value of 2nd property');
}

sub test_user_doesnt_exist : Test(2) {
    my $self = shift;
    
    my $user = RestAuth::User->new($self->{conn}, 'wrongname');
    isa_ok($user, 'RestAuth::User');
    
    throws_ok { $user->create_property('foo', 'bar'); }
        'RestAuth::Error::UserDoesNotExist', 'Try to create property'
}
1;

package RestAuth::Test::Property::Create;
use base qw(RestAuth::Test::PropertyBase);
use Test::More;

sub test_create : Test(2) {
    my $self = shift;
    
    ok($self->{user}->create_property('email', 'mati@restauth.net'), 'Set property');
    is('mati@restauth.net', $self->{user}->get_property('email'), 'Retrieve value again');
}

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