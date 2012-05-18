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

package RestAuth::ContentHandler;

sub encode_array {
}

sub decode {
}

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

1;