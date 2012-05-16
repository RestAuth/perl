package RestAuthUser;

use RestAuthConnection;
use RestAuthError;

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
    my ($class, $conn, $name) = @_;
    
    my $user = $class->new($conn, $name);
    if ($user->exists()) {
        return $user;
    } else {
        throw RestAuthUserDoesNotExist("User does not exist.");
    }
}

sub get_all {
    my ($class, $conn) = @_;

    my $resp = $conn->get($prefix);
    my @users = ();
    my @usernames = $conn->{_content_handler}->decode($resp->content());
    
    foreach (@usernames) {
        push(@users, RestAuthUser->new($conn, $_));
    }

    return @users;
}

sub create {
    my ($class, $conn, $name, $password, $properties) = @_;
    
    my %body = ('user' => $name);
    $body{'password'} = $password if defined $password;
    $body{'properties'} = $properties if defined $properties;
    
    my $response = $conn->post($prefix, \%body);
    if ($response->code == 201) {
        return new RestAuthUser($conn, $name);
    } elsif ($response->code == 409) {
        throw RestAuthConflict($response);
    } elsif ($response->code == 412) {
        throw RestAuthPreconditionFailed($response);
    } else {
        throw RestAuthUnknownStatus($response);
    }
    
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

sub verify_password {
    my ($self, $password) = @_;
    
    my $response = $self->request_post("$self->{_name}/",
                                       {'password' => $password});
    if ($response->code == 204) {
        return 1;
    } elsif ($response->code == 404) {
        return 0;
    } else {
        throw RestAuthUnknownStatus($response);
    }
}

sub set_password {
    my ($self, $password) = @_;
    
    my $response = $self->request_put("$self->{_name}/",
                                      {'password' => $password});
    if ($response->code == 204) {
        return 1;
    } elsif ($response->code == 404) {
        throw RestAuthUserDoesNotExist($response);
    } elsif ($response->code == 412) {
        throw RestAuthPreconditionFailed($response);
    } else {
        throw RestAuthUnknownStatus($response);
    } 
}

sub remove {
    my $self = shift;
    
    my $response = $self->request_delete("$self->{_name}/");
    if ($response->code == 204) {
        return 1;
    } elsif ($response->code == 404) {
        throw RestAuthUserDoesNotExist($response);
    } else {
        throw RestAuthUnknownStatus($response);
    }
}

1;
