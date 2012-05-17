package UserList;
use BaseTest;
use RestAuthUser;
use RestAuthError;
use base qw(BaseTest);

sub test_no_users {
    my $self = shift;
    my @users = RestAuthUser->get_all($self->{conn});
    $self->assert_equals(0, scalar(@users));
}

sub test_one_user {
    my $self = shift;
    
    # first create one user:
    my $user = RestAuthUser->create($self->{conn}, 'username');
    my @expected_users = ($user);
    
    my @users = RestAuthUser->get_all($self->{conn});
    $self->assert_equals(1, scalar(@users));
    $self->assert_equal_resources(\@users, \@expected_users);
}

sub test_two_users {
    my $self = shift;
    
    # first create one user:
    my $user1 = RestAuthUser->create($self->{conn}, 'username1');
    my $user2 = RestAuthUser->create($self->{conn}, 'username2');
    my @expected_users = ($user1, $user2);
    
    my @users = RestAuthUser->get_all($self->{conn});
    $self->assert_equals(2, scalar(@users));
    $self->assert_equal_resources(\@users, \@expected_users);
}

1;

package UserCreate;
use BaseTest;
use RestAuthUser;
use base qw(BaseTest);

sub test_only_username {
    my $self = shift;
    
    $self->assert_raises(RestAuthUserDoesNotExist, sub {
        RestAuthUser->get($self->{conn}, 'username');
    });
    my $user = RestAuthUser->create($self->{conn}, 'username');
    $self->assert($user->exists());
}
sub test_username_and_pass {
    my $self = shift;
    
    $self->assert_raises(RestAuthUserDoesNotExist, sub {
        RestAuthUser->get($self->{conn}, 'username');
    });
    my $user = RestAuthUser->create($self->{conn}, 'username', 'userpassword');
    $self->assert($user->exists());
    $self->assert($user->verify_password('userpassword'));
    $self->assert(! $user->verify_password('false'));
}
sub test_username_and_props {
    my $self = shift;
    my %props = (
        'email' => 'user@example.com',
        'first name' => 'user',
    );
    
    $self->assert_raises(RestAuthUserDoesNotExist, sub {
        RestAuthUser->get($self->{conn}, 'username');
    });
    my $user = RestAuthUser->create($self->{conn}, 'username', undef, \%props);
    $self->assert($user->exists());
    $self->assert(! $user->verify_password('false'));
    
    #TODO: Assert that properties are set!
}
sub test_all_params {
    my $self = shift;
    my %props = (
        'email' => 'user@example.com',
        'first name' => 'user',
    );
    
    $self->assert_raises(RestAuthUserDoesNotExist, sub {
        RestAuthUser->get($self->{conn}, 'username');
    });
    my $user = RestAuthUser->create($self->{conn}, 'username', 'userpassword', \%props);
    $self->assert($user->exists());
    $self->assert($user->verify_password('userpassword'));
    $self->assert(! $user->verify_password('false'));
    
    #TODO: Assert that correct properties are set!
}
sub test_user_exists {
    my $self = shift;
    
    # first regulary create a user
    $self->assert_raises(RestAuthUserDoesNotExist, sub {
        RestAuthUser->get($self->{conn}, 'username');
    });
    my $user = RestAuthUser->create($self->{conn}, 'username', 'orig_password');
    $self->assert($user->exists());
    $self->assert($user->verify_password('orig_password'));
    
    # now create it again!
    $self->assert_raises(RestAuthUserExists, sub {
        RestAuthUser->create($self->{conn}, 'username', 'new_password');
    });
    
    # assert that old password is still correct, not the new one:
    $self->assert($user->exists());
    $self->assert($user->verify_password('orig_password'));
    $self->assert(! $user->verify_password('new_password'));
}
sub test_user_short_password {
    my $self = shift;

        
    $self->assert_raises(RestAuthPreconditionFailed, sub {
        RestAuthUser->create($self->{conn}, 'username', 'a');
    });

    $self->assert_raises(RestAuthUserDoesNotExist, sub {
        RestAuthUser->get($self->{conn}, 'username');
    });
    
    my $user = RestAuthUser->new($self->{conn}, 'username');
    $self->assert(!$user->verify_password('a'));
}

1;

package UserGet;
use BaseTest;
use RestAuthUser;
use base qw(BaseTest);

sub test_ok {};

1;

package UserExists;
use BaseTest;
use RestAuthUser;
use base qw(BaseTest);

sub test_exists {};

1;

package UserVerifyPassword;
use BaseTest;
use RestAuthUser;
use base qw(BaseTest);

sub test_ok {}

1;

package UserSetPassword;
use BaseTest;
use RestAuthUser;
use base qw(BaseTest);

sub test_ok {}

1;

package UserRemove;
use BaseTest;
use RestAuthUser;
use base qw(BaseTest);

sub test_ok {}

1;

