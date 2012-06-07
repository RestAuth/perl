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

=head3 RestAuth::Test::User::List
Test listing users.
=cut
package RestAuth::Test::User::List;
use strict;
use warnings;
use RestAuth::Test::Base;
use base qw(RestAuth::Test::Base);

use Test::More;
use Test::Deep;

use RestAuth::User;

sub test_no_users : Test(1) {
    my $self = shift;
    my @users = RestAuth::User->get_all($self->{conn});
    is(0, scalar(@users));
}

sub test_one_user : Test(2) {
    my $self = shift;
    
    # first create one user:
    my $user = RestAuth::User->create($self->{conn}, 'username');
    isa_ok($user, 'RestAuth::User');
    my @expected_users = ($user);
    
    my @users = RestAuth::User->get_all($self->{conn});
    resources_ok('RestAuth::User', \@users, \@expected_users, 'Check users');
}

sub test_two_users : Test(3) {
    my $self = shift;
    
    # first create one user:
    my $user1 = RestAuth::User->create($self->{conn}, 'username1');
    isa_ok($user1, 'RestAuth::User');
    my $user2 = RestAuth::User->create($self->{conn}, 'username2');
    isa_ok($user2, 'RestAuth::User');
    my @expected_users = ($user1, $user2);
    
    my @users = RestAuth::User->get_all($self->{conn});
    resources_ok('RestAuth::User', \@users, \@expected_users, 'Check users');
}

1;

package RestAuth::Test::User::Create;
use strict;
use warnings;
use RestAuth::Test::Base;
use base qw(RestAuth::Test::Base);

use Test::More;
use Test::Exception;

use RestAuth::User;

sub test_only_username : Test(3) {
    my $self = shift;
    
    throws_ok { RestAuth::User->get($self->{conn}, 'username'); }
        'RestAuth::Error::UserDoesNotExist', 'User does not exist.';
    my $user = RestAuth::User->create($self->{conn}, 'username');
    isa_ok($user, 'RestAuth::User');
    ok($user->exists());
}
sub test_username_and_pass : Test(5) {
    my $self = shift;
    
    throws_ok { RestAuth::User->get($self->{conn}, 'username'); }
        'RestAuth::Error::UserDoesNotExist', 'User does not exist.';
    
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    isa_ok($user, 'RestAuth::User');
    ok($user->exists());
    ok($user->verify_password('userpassword'));
    ok(! $user->verify_password('false'));
}
sub test_username_and_props : Test(4) {
    my $self = shift;
    my %props = (
        'email' => 'user@example.com',
        'first name' => 'user',
    );
    
    throws_ok { RestAuth::User->get($self->{conn}, 'username'); }
        'RestAuth::Error::UserDoesNotExist', 'User does not exist.';
    my $user = RestAuth::User->create($self->{conn}, 'username', undef, \%props);
    isa_ok($user, 'RestAuth::User');
    ok($user->exists());
    ok(! $user->verify_password('false'));
    
    #TODO: Assert that properties are set!
}
sub test_all_params : Test(5) {
    my $self = shift;
    my %props = (
        'email' => 'user@example.com',
        'first name' => 'user',
    );
    
    throws_ok { RestAuth::User->get($self->{conn}, 'username'); }
        'RestAuth::Error::UserDoesNotExist', 'User does not exist.';
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword', \%props);
    isa_ok($user, 'RestAuth::User');
    ok($user->exists());
    ok($user->verify_password('userpassword'));
    ok(! $user->verify_password('false'));
    
    #TODO: Assert that correct properties are set!
}
sub test_user_exists : Test(8) {
    my $self = shift;
    
    # first regulary create a user
    throws_ok { RestAuth::User->get($self->{conn}, 'username'); }
        'RestAuth::Error::UserDoesNotExist', 'User does not exist.';
    my $user = RestAuth::User->create($self->{conn}, 'username', 'orig_password');
    isa_ok($user, 'RestAuth::User');
    ok($user->exists());
    ok($user->verify_password('orig_password'));
    
    # now create it again!
    throws_ok { RestAuth::User->create($self->{conn}, 'username', 'new_password'); }
        'RestAuth::Error::UserExists', 'User does not exist.';
    
    # assert that old password is still correct, not the new one:
    ok($user->exists());
    ok($user->verify_password('orig_password'));
    ok(! $user->verify_password('new_password'));
}
sub test_user_short_password : Test(4) {
    my $self = shift;

    throws_ok { RestAuth::User->create($self->{conn}, 'username', 'a'); }
        'RestAuth::Error::PreconditionFailed', 'Password too short.';
    throws_ok { RestAuth::User->get($self->{conn}, 'username'); }
        'RestAuth::Error::UserDoesNotExist', 'User does not exist.';
    
    my $user = RestAuth::User->new($self->{conn}, 'username');
    isa_ok($user, 'RestAuth::User');
    ok(!$user->verify_password('a'));
}

1;

package RestAuth::Test::User::Get;
use strict;
use warnings;
use RestAuth::Test::Base;
use base qw(RestAuth::Test::Base);

use Test::More;
use Test::Exception;

use RestAuth::User;

sub test_all : Test(5) {
    my $self = shift;
    
    throws_ok { RestAuth::User->get($self->{conn}, 'username'); }
        'RestAuth::Error::UserDoesNotExist', 'User does not exists';
    
    my $created = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    isa_ok($created, 'RestAuth::User');
    my $gotten = RestAuth::User->get($self->{conn}, 'username');
    isa_ok($gotten, 'RestAuth::User');
    
    is($gotten->{_name}, 'username', 'Retrieved username');
    is($created->{_name}, $gotten->{_name}, 'Created username');
};

1;

package RestAuth::Test::User::Exists;
use strict;
use warnings;
use RestAuth::Test::Base;
use base qw(RestAuth::Test::Base);

use Test::More;

use RestAuth::User;

sub test_exists : Test(4) {
    my $self = shift;
    
    my $created = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    isa_ok($created, 'RestAuth::User');
    ok($created->exists());
    
    my $local_instance = new RestAuth::User($self->{conn}, 'username');
    isa_ok($local_instance, 'RestAuth::User');
    ok($local_instance->exists());
};

sub test_doesnt_exist : Test(2) {
    my $self = shift;
    
    my $local_instance = new RestAuth::User($self->{conn}, 'username');
    isa_ok($local_instance, 'RestAuth::User');
    ok(! $local_instance->exists());
}

1;

package RestAuth::Test::User::VerifyPassword;
use strict;
use warnings;
use RestAuth::Test::Base;
use base qw(RestAuth::Test::Base);

use Test::More;

use RestAuth::User;

sub test_ok : Test(2) {
    my $self = shift;
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    isa_ok($user, 'RestAuth::User');
    ok($user->verify_password('userpassword'));
}

sub test_wrong_pass : Test(2) {
    my $self = shift;
    
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    isa_ok($user, 'RestAuth::User');
    ok(!$user->verify_password('false'));
}

sub test_user_doesnt_exist : Test(2) {
    my $self = shift;
    
    my $user = RestAuth::User->new($self->{conn}, 'username');
    isa_ok($user, 'RestAuth::User');
    ok(!$user->verify_password('false'));
}

1;

package RestAuth::Test::User::SetPassword;
use strict;
use warnings;
use RestAuth::Test::Base;
use base qw(RestAuth::Test::Base);

use Test::More;
use Test::Exception;

use RestAuth::User;

sub test_ok : Test(3) {
    my $self = shift;
    
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    isa_ok($user, 'RestAuth::User');
    $user->set_password('newpassword');
    
    ok($user->verify_password('newpassword'));
    ok(!$user->verify_password('userpassword'));
}

sub test_user_doesnt_exist : Test(2) {
    my $self = shift;
    
    my $user = RestAuth::User->new($self->{conn}, 'username');
    isa_ok($user, 'RestAuth::User');
    throws_ok { $user->set_password('newpassword'); }
        'RestAuth::Error::UserDoesNotExist', "User doesn't exist.";
}

sub test_too_short : Test(4) {
    my $self = shift;
    
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    isa_ok($user, 'RestAuth::User');
    
    throws_ok { $user->set_password('a'); }
        'RestAuth::Error::PreconditionFailed', 'Password too short.';
    
    ok($user->verify_password('userpassword'));
    ok(!$user->verify_password('a'));
}
1;

package RestAuth::Test::User::Remove;
use strict;
use warnings;
use RestAuth::Test::Base;
use base qw(RestAuth::Test::Base);

use Test::More;
use Test::Exception;

use RestAuth::User;

sub test_ok : Test(3) {
    my $self = shift;
    
    my $user = RestAuth::User->create($self->{conn}, 'username');
    isa_ok($user, 'RestAuth::User');
    ok($user->exists());
    
    $user->remove();
    
    ok(!$user->exists());
}

sub test_user_doesnt_exist : Test(3) {
    my $self = shift;
    
    my $user = RestAuth::User->new($self->{conn}, 'username');
    isa_ok($user, 'RestAuth::User');
    throws_ok { $user->remove(); } 'RestAuth::Error::UserDoesNotExist', 'User does not exist.';
    ok(!$user->exists());
}

1;