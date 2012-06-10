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

=head1 NAME

RestAuth::User - A user from a RestAuth service

=head1 DESCRIPTION

This class represents a user that is found in a RestAuth service. An instance of
this class can never give you a strong guarantee that the user actually exists.

If you create an instance via the L<constructor|/new>, no interaction with the
RestAuth service happens. This is the recommended way of using RestAuth if you
only want to perform a single operation and/or it is okay to just fail if the
user does not exist.

If you want to make sure that the user exists, call one of the factory methods
L<get|/get_conn_username>, L<get_all|/get_all_conn> or
L<create|/create_conn_username_password_undef_properties_indef>. See the
L</SYNOPSIS> for details.

=head1 SYNOPSIS

    use RestAuth::User;
    use RestAuth::Connection;
    
    # this user may or may not exist remotely:
    $user = RestAuth::user->new("username");
    $user->verify_password("custompass");
    
    # this user does exist remotely, at least right now:
    $conn = RestAuth::Connection("https://auth.example.net", "service", "pass");
    $user2 = RestAuth::User->get($conn, "username");

=head1 METHODS

=cut
package RestAuth::User;
use strict;
use warnings;

use RestAuth::Connection;
use RestAuth::Resource;
use RestAuth::Error::PreconditionFailed;
use RestAuth::Error::PropertyExists;
use RestAuth::Error::PropertyNotFound;
use RestAuth::Error::UnknownStatus;
use RestAuth::Error::UserExists;
use RestAuth::Error::UserNotFound;

our @ISA = qw(RestAuth::Resource);
our $prefix = '/users/';

=head2 get($conn, $username)

Factory method for getting a user from the RestAuth service. An instance
returned by this method is guaranteed to exist.

PARAMETERS:

=over

=item *

B<conn> - L<RestAuth::Connection> - A connection to a RestAuth service.

=item *

B<username> - string - The username of the user.

=back

RETURNS:

=over

=item *

L<RestAuth::User> - A user guaranteed to exist in the RestAuth service

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub get {
    my ($class, $conn, $name) = @_;
    
    my $response = $conn->get("$prefix$name/");
    if ($response->code == 204) {
        return new RestAuth::User($conn, $name);
    } elsif ($response->code == 404) {
        throw RestAuth::Error::UserNotFound($response);
    } else {
        throw RestAuth::Error::UnknownStatus($response);
    }
}

=head2 get_all($conn)

Get all users that exist in a RestAuth Service

PARAMETERS:

=over

=item *

B<conn> - L<RestAuth::Connection> - A connection to a RestAuth service.

=back

RETURNS:

=over

=item *

Array of L<users|RestAuth::User> - An array of users known to exist.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub get_all {
    my ($class, $conn) = @_;

    my $resp = $conn->get($prefix);
    my @users = ();
    my @usernames = $conn->decode_list($resp->content());
    
    foreach (@usernames) {
        push(@users, RestAuth::User->new($conn, $_));
    }

    return @users;
}

=head2 create($conn, $username, $password=undef, \%properties=undef)

Create a new user in the RestAuth service.

PARAMETERS:

=over

=item *

B<conn> - L<RestAuth::Connection> - A connection to a RestAuth service.

=item *

B<username> - string - The username of the user.

=item *

B<password> (optional) - string - The password of the new user.

=item *

B<properties> (optional) - Hash of intial properties

=back

RETURNS:

=over

=item *

L<RestAuth::User> - A user guaranteed to exist in the RestAuth service.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
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

=head2 exists()

Verify that a user exists in a RestAuth service.

RETURNS:

=over

=item *

B<boolean> - 1 if the user exists, 0 otherwise.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
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

=head2 verify_password($password)

Verify a users password.

PARAMETERS:

=over

=item *

B<password> - string - The password to verify.

=back

RETURNS:

=over

=item *

B<boolean> - 1 if the password is correct, 0 otherwise.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
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

=head2 set_password($password)

Set a new password.

PARAMETERS:

=over

=item *

B<password> - string - The new password to set.

=back

RETURNS:

=over

=item *

B<boolean> - Always returns 1.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
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
        throw RestAuth::Error::UserNotFound($response);
    } elsif ($response->code == 412) {
        throw RestAuth::Error::PreconditionFailed($response);
    } else {
        throw RestAuth::Error::UnknownStatus($response);
    } 
}

=head2 remove()

Remove a user from RestAuth.

RETURNS:

=over

=item *

B<boolean> - Always returns 1.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub remove {
    my $self = shift;
    
    my $response = $self->request_delete("$self->{_name}/");
    if ($response->code == 204) {
        return 1;
    } elsif ($response->code == 404) {
        throw RestAuth::Error::UserNotFound($response);
    } else {
        throw RestAuth::Error::UnknownStatus($response);
    }
}

=head2 get_properties()

RETURNS:

=over

=item *

B<Hash> - A Hash representing the properties. The keys represent the
properties while the value represent their respective value.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub get_properties {
    my $self = shift;
    
    my $resp = $self->request_get($self->{_name} . '/props/');
    if ($resp->code == 200) {
        my %props = $self->{_conn}->decode_dict($resp->content());
        return %props;
    } elsif ($resp->code == 404) {
        throw RestAuth::Error::UserNotFound($resp);
    } else {
        throw RestAuth::Error::UnknownStatus($resp);
    }
}

=head2 create_property($name, $value)

Create a new property. It is an error if the given property already
exists.

PARAMETERS:

=over

=item *

B<name> - string - The name of the new property.

=item *

B<value> - string - The value of the new property.

=back

RETURNS:

=over

=item *

B<boolean> - Always returns 1.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub create_property {
    my ($self, $name, $value) = @_;
    
    my %body = ('prop' => $name, 'value' => $value);
    
    my $resp = $self->request_post($self->{_name} . '/props/', \%body);
    if ($resp->code == 201) {
        return 1;
    } elsif ($resp->code == 404) {
        throw RestAuth::Error::UserNotFound($resp);
    } elsif ($resp->code == 409) {
        throw RestAuth::Error::PropertyExists($resp);
    } else {
        throw RestAuth::Error::UnknownStatus($resp);
    }   
}

=head2 get_property($name)

Get the value of the given property.

PARAMETERS:

=over

=item *

B<name> - string - The name of the property to get.

=back

RETURNS:

=over

=item *

B<string> - The value of the property.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub get_property {
    my ($self, $name) = @_;
    
    my $resp = $self->request_get($self->{_name} . "/props/$name/");
    if ($resp->code == 200) {
        my @raw = $self->{_conn}->decode_list($resp->content());
        return $raw[0];
    } elsif ($resp->code == 404) {
        if ($resp->header('Resource-Type') eq 'user') {
            throw RestAuth::Error::UserNotFound($resp);
        } elsif ($resp->header('Resource-Type') eq 'property') {
            throw RestAuth::Error::PropertyNotFound($resp);
        } else {
            throw RestAuth::Error::UnknownStatus($resp);
        }
    } else {
        throw RestAuth::Error::UnknownStatus($resp);
    } 
}

=head2 set_property($name, $value)

Set a new value for a property. If the value does not exist, it is created.

PARAMETERS:

=over

=item *

B<name> - string - The name of value to set.

=item *

B<value> - string - The new value.

=back

RETURNS:

=over

=item *

B<string> or B<boolean> - 1 if the property was created or the old value
if an existing property was overwritten.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub set_property {
    my ($self, $key, $value) = @_;
    
    my %body = ('value' => $value);
    my $resp = $self->request_put("$self->{_name}/props/$key/", \%body);
    if ($resp->code == 200) {
        return $self->{_conn}->decode_str($resp->content());
    } elsif ($resp->code == 201) {
        return 1;
    } elsif ($resp->code == 404) {
        throw RestAuth::Error::UserNotFound($resp);
    } else {
        throw RestAuth::Error::UnknownStatus($resp);
    }
}

=head2 remove_property($name)

Remove a property.

PARAMETERS:

=over

=item *

B<name> - string - The property to remove.

=back

RETURNS:

=over

=item *

B<boolean> - Always returns 1.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub remove_property {
    my ($self, $key) = @_;
    
    my $resp = $self->request_delete("$self->{_name}/props/$key/");
    if ($resp->code == 204) {
        return 1;
    } elsif ($resp->code == 404) {
        if ($resp->header('Resource-Type') eq 'user') {
            throw RestAuth::Error::UserNotFound($resp);
        } elsif ($resp->header('Resource-Type') eq 'property') {
            throw RestAuth::Error::PropertyNotFound($resp);
        } else {
            throw RestAuth::Error::UnknownStatus($resp);
        }
    } else {
        throw RestAuth::Error::UnknownStatus($resp);    
    } 
}

=head1 BUGS

To report bugs in this library please either join our RestAuth XMPP channel
found at restauth@conference.jabber.at or file an issue in L<our bugtracker
|https://redmine.fsinf.at/projects/restauth-perl>.

=head1 LICENSE

Copyright 2012, Mathias Ertl L<mati@restauth.net|mailto:mati@restauth.net>

This software is free. It is licensed under the
L<GNU General Public License, version 3|http://www.gnu.org/copyleft/gpl.html>.

The latest version of this software should be available via
L<our git repository|https://git.fsinf.at/restauth/perl> or via this projects
homepage, L<perl.restauth.net|https://perl.restauth.net>.

=cut

1;