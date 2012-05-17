package UserList;
use BaseTest;
use RestAuth::User;
use RestAuth::Error;
use base qw(BaseTest);

sub test_no_users {
    my $self = shift;
    my @users = RestAuth::User->get_all($self->{conn});
    $self->assert_equals(0, scalar(@users));
}

sub test_one_user {
    my $self = shift;
    
    # first create one user:
    my $user = RestAuth::User->create($self->{conn}, 'username');
    my @expected_users = ($user);
    
    my @users = RestAuth::User->get_all($self->{conn});
    $self->assert_equals(1, scalar(@users));
    $self->assert_equal_resources(\@users, \@expected_users);
}

sub test_two_users {
    my $self = shift;
    
    # first create one user:
    my $user1 = RestAuth::User->create($self->{conn}, 'username1');
    my $user2 = RestAuth::User->create($self->{conn}, 'username2');
    my @expected_users = ($user1, $user2);
    
    my @users = RestAuth::User->get_all($self->{conn});
    $self->assert_equals(2, scalar(@users));
    $self->assert_equal_resources(\@users, \@expected_users);
}

1;

package UserCreate;
use BaseTest;
use RestAuth::User;
use base qw(BaseTest);

sub test_only_username {
    my $self = shift;
    
    $self->assert_raises(RestAuth::Error::UserDoesNotExist, sub {
        RestAuth::User->get($self->{conn}, 'username');
    });
    my $user = RestAuth::User->create($self->{conn}, 'username');
    $self->assert($user->exists());
}
sub test_username_and_pass {
    my $self = shift;
    
    $self->assert_raises(RestAuth::Error::UserDoesNotExist, sub {
        RestAuth::User->get($self->{conn}, 'username');
    });
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
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
    
    $self->assert_raises(RestAuth::Error::UserDoesNotExist, sub {
        RestAuth::User->get($self->{conn}, 'username');
    });
    my $user = RestAuth::User->create($self->{conn}, 'username', undef, \%props);
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
    
    $self->assert_raises(RestAuth::Error::UserDoesNotExist, sub {
        RestAuth::User->get($self->{conn}, 'username');
    });
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword', \%props);
    $self->assert($user->exists());
    $self->assert($user->verify_password('userpassword'));
    $self->assert(! $user->verify_password('false'));
    
    #TODO: Assert that correct properties are set!
}
sub test_user_exists {
    my $self = shift;
    
    # first regulary create a user
    $self->assert_raises(RestAuth::Error::UserDoesNotExist, sub {
        RestAuth::User->get($self->{conn}, 'username');
    });
    my $user = RestAuth::User->create($self->{conn}, 'username', 'orig_password');
    $self->assert($user->exists());
    $self->assert($user->verify_password('orig_password'));
    
    # now create it again!
    $self->assert_raises(RestAuth::Error::UserExists, sub {
        RestAuth::User->create($self->{conn}, 'username', 'new_password');
    });
    
    # assert that old password is still correct, not the new one:
    $self->assert($user->exists());
    $self->assert($user->verify_password('orig_password'));
    $self->assert(! $user->verify_password('new_password'));
}
sub test_user_short_password {
    my $self = shift;

        
    $self->assert_raises(RestAuth::Error::PreconditionFailed, sub {
        RestAuth::User->create($self->{conn}, 'username', 'a');
    });

    $self->assert_raises(RestAuth::Error::UserDoesNotExist, sub {
        RestAuth::User->get($self->{conn}, 'username');
    });
    
    my $user = RestAuth::User->new($self->{conn}, 'username');
    $self->assert(!$user->verify_password('a'));
}

1;

package UserGet;
use BaseTest;
use RestAuth::User;
use base qw(BaseTest);

sub test_all {
    my $self = shift;
    
    $self->assert_raises(RestAuth::Error::UserDoesNotExist, sub {
        RestAuth::User->get($self->{conn}, 'username');
    });
    
    my $created = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    my $gotten = RestAuth::User->get($self->{conn}, 'username');
    
    $self->assert_equals($gotten->{_name}, 'username');
    $self->assert_equals($created->{_name}, $gotten->{_name});
};

1;

package UserExists;
use BaseTest;
use RestAuth::User;
use base qw(BaseTest);

sub test_exists {
    my $self = shift;
    
    my $created = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    $self->assert($created->exists());
    
    my $local_instance = new RestAuth::User($self->{conn}, 'username');
    $self->assert($local_instance->exists());
};

sub test_doesnt_exist {
    my $self = shift;
    
    my $local_instance = new RestAuth::User($self->{conn}, 'username');
    $self->assert(! $local_instance->exists());
}

1;

package UserVerifyPassword;
use BaseTest;
use RestAuth::User;
use base qw(BaseTest);

sub test_ok {
    my $self = shift;
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    $self->assert($user->verify_password('userpassword'));
}

sub test_wrong_pass {
    my $self = shift;
    
    my $user = RestAuth::User->create($self->{conn}, 'username', 'userpassword');
    $self->assert(!$user->verify_password('false'));
}

sub test_user_doesnt_exist {
    my $self = shift;
    
    my $user = RestAuth::User->new($self->{conn}, 'username');
    $self->assert(!$user->verify_password('false'));
}

1;

package UserSetPassword;
use BaseTest;
use RestAuth::User;
use base qw(BaseTest);

sub test_ok {
    my $self = shift;
}

sub test_wrong_password {
    my $self = shift;
}

sub test_user_doesnt_exist {
    my $self = shift;
}

sub test_too_short {}
1;

package UserRemove;
use BaseTest;
use RestAuth::User;
use base qw(BaseTest);

sub test_ok {
    my $self = shift;
}

sub test_user_doesnt_exist {
    my $self = shift;
}

1;

package BasicUserTests;
use base qw(Test::Unit::TestSuite);

sub include_tests {
    qw(UserList UserCreate UserGet UserExists UserVerifyPassword UserSetPassword UserRemove)
}
1;

