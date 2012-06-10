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

=head3 RestAuth::Test::Property::GetAll
Property-related tests.
=cut
package RestAuth::Test::Property::GetAll;
use RestAuth::Test;
use base qw(RestAuth::Test::PropertyBase);
use strict;
use warnings;

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
    
    throws_ok { $user->get_properties(); }
        'RestAuth::Error::UserNotFound', 'Try getting properties';
}
1;

package RestAuth::Test::Property::Create;
use base qw(RestAuth::Test::PropertyBase);
use strict;
use warnings;

use Test::More;
use Test::Exception;

sub test_create : Test(2) {
    my $self = shift;
    
    ok($self->{user}->create_property('email', 'mati@restauth.net'), 'Set property');
    is('mati@restauth.net', $self->{user}->get_property('email'), 'Retrieve value again');
}

sub test_create_conflict : Test(3) {
    my $self = shift;
    
    ok($self->{user}->create_property('email', 'mati@restauth.net'), 'Set property');
    throws_ok { $self->{user}->create_property('email', 'mati@fsinf.at') }
        'RestAuth::Error::PropertyExists', 'Set property';
    is('mati@restauth.net', $self->{user}->get_property('email'), 'Retrieve value again');
}

sub test_create_user_doesnt_exist : Test(2) {
    my $self = shift;
    
    my $user = RestAuth::User->new($self->{conn}, 'wrongname');
    isa_ok($user, 'RestAuth::User');
    
    throws_ok { $user->create_property('foo', 'bar'); }
        'RestAuth::Error::UserNotFound', 'Try to create property';
}

1;

package RestAuth::Test::Property::Get;
use base qw(RestAuth::Test::PropertyBase);
use strict;
use warnings;

use Test::More;
use Test::Exception;

sub test_get : Test(2) {
    my $self = shift;
    
    ok($self->{user}->create_property('email', 'mati@restauth.net'), 'Create property');
    is('mati@restauth.net', $self->{user}->get_property('email'), 'Retrieve value again');
}

sub test_user_doesnt_exist : Test(2) {
    my $self = shift;
    
    my $user = RestAuth::User->new($self->{conn}, 'wrongname');
    isa_ok($user, 'RestAuth::User');
    
    throws_ok { $user->get_property('foo', 'bar'); }
        'RestAuth::Error::UserNotFound', 'Try to get property';
}

sub test_prop_doesnt_exist : Test(1) {
    my $self = shift;
    
    throws_ok { $self->{user}->get_property('email'); }
        'RestAuth::Error::PropertyNotFound', 'Retrieve not-existing value';
}

1;

package RestAuth::Test::Property::Set;
use base qw(RestAuth::Test::PropertyBase);
use strict;
use warnings;

use Test::More;
use Test::Exception;

sub test_create : Test(2) {
    my $self = shift;
    
    is($self->{user}->set_property('email', 'mati@restauth.net'), 1, 'Create property');
    is($self->{user}->get_property('email'), 'mati@restauth.net', 'Retrieve value again');
}

sub test_update : Test(4) {
    my $self = shift;
    
    is($self->{user}->create_property('email', 'mati@restauth.net'), 1, 'Create property');
    is($self->{user}->get_property('email', 'mati@restauth.net'), 'mati@restauth.net', 'Retrieve value again');
    
    is($self->{user}->set_property('email', 'mati@fsinf.at'), 'mati@restauth.net', 'Set value again');
    is($self->{user}->get_property('email'),'mati@fsinf.at', 'Retrieve value again');
}

sub test_user_doesnt_exist : Test(2) {
    my $self = shift;
    
    my $user = RestAuth::User->new($self->{conn}, 'wrongname');
    isa_ok($user, 'RestAuth::User');
    
    throws_ok { $user->set_property('email', 'mati@restauth.net'); }
        'RestAuth::Error::UserNotFound', 'Try to set property';
}

1;

package RestAuth::Test::Property::Remove;
use base qw(RestAuth::Test::PropertyBase);
use strict;
use warnings;

use Test::More;
use Test::Exception;

sub test_remove : Test(3) {
    my $self = shift;
    
    is($self->{user}->create_property('email', 'mati@restauth.net'), 1, 'Create property');
    is($self->{user}->remove_property('email'), 1, 'Delete property');
    
    throws_ok { $self->{user}->get_property('email'); }
        'RestAuth::Error::PropertyNotFound', 'Try to retrieve it again';
}

sub test_user_doesnt_exist : Test(2) {
    my $self = shift;
    
    my $user = RestAuth::User->new($self->{conn}, 'wrongname');
    isa_ok($user, 'RestAuth::User');
    
    throws_ok { $user->remove_property('email'); }
        'RestAuth::Error::UserNotFound', 'Try to delete inexistent property';
}

sub test_prop_doesnt_exist : Test(1) {
    my $self = shift;
    
    throws_ok { $self->{user}->remove_property('email'); }
        'RestAuth::Error::PropertyNotFound', 'Try to delete inexistent property';
}

1;