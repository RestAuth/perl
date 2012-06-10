# This file is part of RestAuth.pm.
#
# RestAuth.pm is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RestAuth.pm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with RestAuth.pm.  If not, see <http://www.gnu.org/licenses/>.

=head1 NAME

RestAuth::Group - A group from a RestAuth service

=head1 DESCRIPTION

=head1 SYNOPSIS

=head1 METHODS

=cut
package RestAuth::Group;
use strict;
use warnings;

use RestAuth::Resource;
use base qw(RestAuth::Resource);

use RestAuth::Error::GroupNotFound;
use RestAuth::Error::GroupExists;
use RestAuth::Error::PreconditionFailed;
use RestAuth::Error::UnknownStatus;

our $prefix = '/groups/';

=head2 get_all($conn, $username=undef)

Get all groups that exist in a RestAuth Service

PARAMETERS:

=over

=item *

B<conn> - L<RestAuth::Connection> - A connection to a RestAuth service.

=item *

B<username> (optional) - string - Only return groups that user with given name
is a member of.

=back

RETURNS:

=over

=item *

Array of L<users|RestAuth::Group> - An array of groups known to exist.

=back

THROWS:

=over

=item *

B<TODO>

=back


=cut
sub get_all {
    my ($class, $conn, $username) = @_;
    my $resp;
    if (defined $username) {
        my %params = ('user' => $username);
        $resp = $conn->get($prefix, \%params);
    } else {
        $resp = $conn->get($prefix);
    }
    my @groups = ();
    my @groupnames = $conn->decode_list($resp->content());
    
    foreach (@groupnames) {
        push(@groups, RestAuth::Group->new($conn, $_));
    }

    return @groups;
}

sub get {
    my ($self, $conn, $name) = @_;
}

=head2 create($conn, $name)

Create a new group in the RestAuth service.

PARAMETERS:

=over

=item *

B<conn> - L<RestAuth::Connection> - A connection to a RestAuth service.

=item *

B<username> - string - The name of the group.

=back

RETURNS:

=over

=item *

L<RestAuth::Group> - A group guaranteed to exist in the RestAuth service.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub create {
    my ($self, $conn, $name) = @_;
    
    my %body = ('group' => $name);
    my $response = $conn->post($prefix, \%body);
    if ($response->code == 201) {
        return new RestAuth::Group($conn, $name);
    } elsif ($response->code == 409) {
        throw RestAuth::Error::GroupExists($response);
    } elsif ($response->code == 412) {
        throw RestAuth::Error::PreconditionFailed($response);
    } else {
        throw RestAuth::Error::UnknownStatus($response);
    }
}

=head2 exists()

Verify that the group actually exists.

RETURNS:

=over

=item *

B<boolean> - 1 if the group exists, 0 otherwise.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub exists {
    my ($self) = @_;
    
    my $response = $self->request_get("$self->{_name}/");
    if ($response->code == 204) {
        return 1;
    } elsif ($response->code == 404) {
        return 0;
    } else {
        throw RestAuth::Error::UnknownStatus($response);
    }
}

sub add_user {
    my ($self, $user) = @_;
}

sub get_users {
    my ($self) = @_;
}

sub remove_user {
    my ($self, $user) = @_;
}

sub add_group {
    my ($self, $group) = @_;
}

sub get_groups {
    my ($self) = @_;
}

sub remove_group {
    my ($self, $group) = @_;
}

=head2 remove()

Remove the group from RestAuth.

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
        throw RestAuth::Error::GroupNotFound($response);
    } else {
        throw RestAuth::Error::UnknownStatus($response);
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