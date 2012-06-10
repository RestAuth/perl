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

RestAuth::Error::PropertyExists - Tried to create a property that already exists

=head1 DESCRIPTION

Thrown when you try to create a property that already exists. Note that this
exception is only thrown by
L<RestAuth::User-E<gt>create_property|RestAuth::User/create_property_name_value>
and not
L<RestAuth::User-E<gt>set_property|RestAuth::User/set_property_name_value>,
because setting an existing property is not an error.

=head1 INHERITANCE

=over

=item *

B<Superclasses:> L<RestAuth::Error::Conflict>

=back

=cut
package RestAuth::Error::PropertyExists;
use base RestAuth::Error::Conflict;

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