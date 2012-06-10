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

RestAuth::Error::UnsupportedMediaType - Sent content in wrong format.

=head1 DESCRIPTION

Thrown when the library sends a HTTP request body in a content format
that the server does not understand.

=head1 INHERITANCE

=over

=item *

B<Superclasses:> L<RestAuth::Error::Http>

=back

=cut
package RestAuth::Error::UnsupportedMediaType;
use base RestAuth::Error::Http;
our $code = 415;

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