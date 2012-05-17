package UserList;
use BaseTest;
use RestAuthUser;
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

sub test_ok {}

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

