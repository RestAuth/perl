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

RestAuth::Resource - Baseclass for users and groups.

=head1 DESCRIPTION

This class acts as a small baseclass for L<RestAuth::User> and
L<RestAuth::Group>. The only functionality is a unified constructor and
shortcuts for HTTP methods that prefix the path passed to them with either
C</users/> or C</groups/>.

=head1 METHODS

=cut

package RestAuth::Resource;

=head2 new($conn, $name)

Basic constructor.

PARAMETERS:

=over

=item *

B<conn> - L<RestAuth::Connection> - The connection to use.

=item *

B<name> - string - The name of the resource.

=back

=cut
sub new {
    my $class = shift;
    my $self = {
        _conn => shift,
        _name => shift,
    };

    bless $self, $class;        
    return $self;
}

=head2 request_get

Do a HTTP GET reqest at the given path.

Parameters:

=over

=item *

B<path> - The path to use for the GET request.

=back

RETURNS:

=over

=item *

L<HTTP::Response|http://search.cpan.org/~gaas/HTTP-Message-6.03/lib/HTTP/Response.pm>
 - The response to the request.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub request_get {
    my ($self, $path, $parameters) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->get($path, $parameters);
}

=head2 request_post

Do a HTTP POST reqest at the given path with the given request body.

Parameters:

=over

=item *

B<path> - The path for the POST request.

=item *

B<body> - The request body.

=back

RETURNS:

=over

=item *

L<HTTP::Response|http://search.cpan.org/~gaas/HTTP-Message-6.03/lib/HTTP/Response.pm>
 - The response to the request.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub request_post {
    my ($self, $path, $body) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->post($path, $body);
}

=head2 request_put

Do a HTTP PUT reqest at the given path with the given request body.

Parameters:

=over

=item *

B<path> - The path for the PUT request.

=item *

B<body> - The request body.

=back

=cut
sub request_put {
    my ($self, $path, $body) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->put($path, $body);
}

=head2 request_delete

Do a HTTP DELETE reqest at the given path.

Parameters:

=over

=item *

B<path> - The path for the DELETE request.

=back

RETURNS:

=over

=item *

L<HTTP::Response|http://search.cpan.org/~gaas/HTTP-Message-6.03/lib/HTTP/Response.pm>
 - The response to the request.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub request_delete {
    my ($self, $path) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->delete($path);
}

=head2 prefix

Get this concrete classes prefix for URL paths.

=cut    
sub prefix {
    my $self = shift;
    my $class = ref($self) || $self;
    my $varname = $class . "::prefix";
    no strict 'refs';
    return $$varname;
}

1;