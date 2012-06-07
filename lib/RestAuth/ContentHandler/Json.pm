package RestAuth::ContentHandler::Json;
use RestAuth::ContentHandler;
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