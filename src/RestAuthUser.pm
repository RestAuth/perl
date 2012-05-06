package RestAuthUser;
use RestAuthConnection;
use RestAuthError;
use JSON;

our @ISA = qw(RestAuthResource);
our $prefix = '/users/';

sub new {
    my $class = shift;
    my $self = {
        _conn => shift,
        _name => shift,
    };

    bless $self, $class;        
    return $self;
}

sub get {
    my $class = shift;
    my $conn = shift;
    my $name = shift;
    
    my $user = $class->new($conn, $name);
    if ($user->exists()) {
        return $user;
    } else {
        throw RestAuthUserDoesNotExist("User does not exist.");
    }
}

sub get_all {
    my $class = shift;
    my $conn = shift;

    my $resp = $conn->get('/users/');
    my @users;
    my @usernames = @{decode_json($resp->content())};
    foreach (@usernames) {
        push(@users, RestAuthUser->new($conn, $_));
    }

    return $users;
}

sub exists {
    my $self = shift;
    my $response = $self->request_get("$self->{_name}/");
    if ($response->code == 204) {
        return 1;
    } elsif ($response->code == 404) {
        return 0;
    } else {
        throw RestAuthUnknownStatus($response);
    }
}
1;
