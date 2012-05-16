package UserList;
use BaseTest;
use RestAuthUser;
use base qw(BaseTest);

#our $conn = new RestAuthConnection('http://[::1]:8000', 'example.com', 'example');

sub test_no_users {
    my $self = shift;
    my $users = RestAuthUser->get_all($self->{conn});
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

