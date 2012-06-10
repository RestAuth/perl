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

RestAuth::Error::Http - Superclass for all exceptions caused by HTTP responses.

=head1 DESCRIPTION

This class is a superclass for all exceptions thrown when doing an HTTP request
and the server response indicates an error of some kind.

=head1 INHERITANCE

=over

=item *

B<Superclasses:> L<RestAuth::Error::Base>

=item *

B<Subclasses:>
L<RestAuth::Error::Conflict>,
L<RestAuth::Error::NotFound>,
L<RestAuth::Error::PreconditionFailed>,
L<RestAuth::Error::Unauthorized>,
L<RestAuth::Error::UnknownStatus>,
L<RestAuth::Error::UnsupportedMediaType>,

=back

=head1 METHODS

=cut
package RestAuth::Error::Http;
use base RestAuth::Error::Base;

=head2 new($response)

Basic constructor.

PARAMETERS:

=over

=item *

B<response> - 
L<HTTP::Response|http://search.cpan.org/~gaas/HTTP-Message-6.03/lib/HTTP/Response.pm>
- The response send by the server.

=back
=cut
sub new {
    my $self = shift;
    $self->{response} = shift;
    $self->SUPER::new($self->{response}->content);
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