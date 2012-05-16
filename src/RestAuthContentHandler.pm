package RestAuthContentHandler;

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

package RestAuthJsonContentHandler;
use JSON;

our @ISA = qw(RestAuthContentHandler);
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

sub decode {
    my ($self, $raw) = @_;
    return decode_json($raw);
}

1;