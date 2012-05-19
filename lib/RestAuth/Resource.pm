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

package RestAuth::Resource;

=head1 NAME

RestAuth::Resource - second test

=cut


sub new {
    my $class = shift;
    my $self = {
        _conn => shift,
    };

    bless $self, $class;
    return $self;
}

sub request_get {
    my ($self, $path) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->get($path);
}

sub request_post {
    my ($self, $path, $body) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->post($path, $body);
}

sub request_put {
    my ($self, $path, $body) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->put($path, $body);
}

sub request_delete {
    my ($self, $path) = @_;
    $path = $self->prefix . $path;
    
    return $self->{_conn}->delete($path);
}

sub prefix {
    my $self = shift;
    my $class = ref($self) || $self;
    my $varname = $class . "::prefix";
    no strict 'refs';
    return $$varname;
}

1;