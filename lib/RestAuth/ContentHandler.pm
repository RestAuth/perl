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

=head1 RestAuth::ContentHandler

Baseclass for content handlers. Instances of this object can be
passed to
L<set_content_handler|RestAuth::Connection/set_content_handler_content_handler>
if you want your connection to use a different data format.

This is an abstract class and has only method stubs. This class
documentation may be used if you want to implement your own subclasses.

=cut
package RestAuth::ContentHandler;

=head2 encode_array(\%data)

Encode an array.

PARAMETERS:

=over

=item *

B<data> - Array - An array of key/value pairs to encode.

=back

RETURNS:

=over

=item *

B<string> - The encoded data.

=back

=cut
sub encode_array {}

=head2 decode_list($raw_data)

PARAMETERS:

=over

=item *

B<raw_data> - string - The encoded data.

=back

RETURNS:

=over

=item *

B<Array> - The decoded list.

=back

=cut
sub decode_list {}

=head2 decode_dict($raw_data)

PARAMETERS:

=over

=item *

B<raw_data> - string - The encoded data.

=back

RETURNS:

=over

=item *

B<Hash> - The decoded dictionary.

=back

=cut
sub decode_dict {}

=head2 decode_str($raw_data)

PARAMETERS:

=over

=item *

B<raw_data> - string - The encoded data.

=back

RETURNS:

=over

=item *

B<string> - The decoded string.

=back

=cut
sub decode_str {}

sub mime_type {
    my $self = shift;
    my $class = ref($self) || $self;
    my $varname = $class . "::_mime_type";
    no strict 'refs';
    return $$varname;
}

1;

package RestAuth::JsonContentHandler;
use JSON;

our @ISA = qw(RestAuth::ContentHandler);
our $_mime_type = 'application/json';

sub new {
    my $class = shift;
    my $self = {
        _conn => shift,
        _name => shift,
    };

    bless $self, $class;        
    return $self;
}

sub encode_array {
    my ($self, $data) = @_;
    return encode_json(\%{$data});
}

sub decode_list {
    my ($self, $raw) = @_;
    return @{decode_json($raw)};
}

sub decode_dict {
    my ($self, $raw) = @_;
    return %{decode_json($raw)};
}

sub decode_str {
    my ($self, $raw) = @_;
    return @{decode_json($raw)}[0];
}

1;