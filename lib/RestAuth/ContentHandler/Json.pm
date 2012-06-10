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

RestAuth::ContentHandler::Json - Encode/decode from/to JSON

=head1 DESCRIPTION

This class is the default content handler used by L<RestAuth::Connection>.

=head1 SYNOPSYS

Please see L<RestAuth::ContentHandler>.

=head1 INHERITANCE

=over

=item *

B<Superclasses:> L<RestAuth::ContentHandler>

=back

=head1 METHODS

=cut
package RestAuth::ContentHandler::Json;
use RestAuth::ContentHandler;
use JSON;

our @ISA = qw(RestAuth::ContentHandler);
our $_mime_type = 'application/json';

=head2 encode_dict(\%data)

See L<RestAuth::ContentHandler-E<gt>encode_dict()|RestAuth::ContentHandler/encode_dict_data>.

=cut
sub encode_dict {
    my ($self, $data) = @_;
    return encode_json(\%{$data});
}

=head2 decode_list($raw_data)

See L<RestAuth::ContentHandler-E<gt>decode_list()|RestAuth::ContentHandler/decode_list_raw_data>.

=cut
sub decode_list {
    my ($self, $raw) = @_;
    return @{decode_json($raw)};
}

=head2 decode_dict($raw_data)

See L<RestAuth::ContentHandler-E<gt>decode_dict()|RestAuth::ContentHandler/decode_dict_raw_data>.

=cut
sub decode_dict {
    my ($self, $raw) = @_;
    return %{decode_json($raw)};
}

=head2 decode_str($raw_data)

See L<RestAuth::ContentHandler-E<gt>decode_str()|RestAuth::ContentHandler/decode_str_raw_data>.

=cut
sub decode_str {
    my ($self, $raw) = @_;
    return @{decode_json($raw)}[0];
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