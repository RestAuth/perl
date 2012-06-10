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

=head1 RestAuth::Group

A group in RestAuth.

=cut
package RestAuth::Group;
use strict;
use warnings;

use RestAuth::Resource;
use base qw(RestAuth::Resource);

our $prefix = '/groups/';

sub get_all {
    my ($self, $conn) = @_;
}

sub get {
    my ($self, $conn, $name) = @_;
}

sub create {
    my ($self, $conn, $name) = @_;
}

sub exists {
    my ($self) = @_;
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