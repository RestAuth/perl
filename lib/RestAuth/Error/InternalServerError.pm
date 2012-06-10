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

RestAuth::Error::InternalServerError - Server suffered from some internal problem

=head1 DESCRIPTION

Thrown when the RestAuth server suffered from some internal problem. This may be
caused by a multitude of problems such as the database connection not working,
some permissions not working, ... and it may or may not make sense to try again
without human intervention on the server-side.

It is typical to display a generic error message to the user and notify system
administrators of this problem.

=head1 INHERITANCE

=over

=item *

B<Superclasses:> L<RestAuth::Error::Http>

=back

=cut
package RestAuth::Error::InternalServerError;
use base RestAuth::Error::Http;
our $code = 500;

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