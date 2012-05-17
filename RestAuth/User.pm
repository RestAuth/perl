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

package RestAuth::User;

use RestAuth::Connection;
use RestAuth::Error;

our @ISA = qw(RestAuth::Resource);
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
    
    my $response = $conn->get("$prefix$name/");
    if ($response->code == 204) {
        return new RestAuth::User($conn, $name);
    } elsif ($response->code == 404) {
        throw RestAuth::Error::UserDoesNotExist($response);
    } else {
        throw RestAuth::Error::UnknownStatus($response);
    }
}

sub get_all {
    my ($class, $conn) = @_;

    my $resp = $conn->get($prefix);
    my @users = ();
    my @usernames = $conn->{_content_handler}->decode($resp->content());
    
    foreach (@usernames) {
        push(@users, RestAuth::User->new($conn, $_));
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
        return new RestAuth::User($conn, $name);
    } elsif ($response->code == 409) {
        throw RestAuth::Error::UserExists($response);
    } elsif ($response->code == 412) {
        throw RestAuth::Error::PreconditionFailed($response);
    } else {
        throw RestAuth::Error::UnknownStatus($response);
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
        throw RestAuth::Error::UnknownStatus($response);
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
        throw RestAuth::Error::UnknownStatus($response);
    }
}

sub set_password {
    my ($self, $password) = @_;
    
    my %body = ();
    if ($password) {
        $body{'password'} = $password;
    }
    
    my $response = $self->request_put("$self->{_name}/", \%body);
    if ($response->code == 204) {
        return 1;
    } elsif ($response->code == 404) {
        throw RestAuth::Error::UserDoesNotExist($response);
    } elsif ($response->code == 412) {
        throw RestAuth::Error::PreconditionFailed($response);
    } else {
        throw RestAuth::Error::UnknownStatus($response);
    } 
}

sub remove {
    my $self = shift;
    
    my $response = $self->request_delete("$self->{_name}/");
    if ($response->code == 204) {
        return 1;
    } elsif ($response->code == 404) {
        throw RestAuth::Error::UserDoesNotExist($response);
    } else {
        throw RestAuth::Error::UnknownStatus($response);
    }
}

1;
