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

=head1 RestAuth::Resource

Baseclass for users and groups.

=cut

package RestAuth::Resource;

=head2 new

Basic constructor.

=over

=item *

B<TODO:> Unify constructor of base-classes here.

=back

=cut
sub new {
    my $class = shift;
    my $self = {
        _conn => shift,
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

=cut
sub request_get {
    my ($self, $path) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->get($path);
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

=cut
sub request_delete {
    my ($self, $path) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->delete($path);
}

=head2 prefix

Get this concrete classes prefix for ULR paths.

=cut    
sub prefix {
    my $self = shift;
    my $class = ref($self) || $self;
    my $varname = $class . "::prefix";
    no strict 'refs';
    return $$varname;
}

1;