package RestAuthUser;
use RestAuthConnection
our @ISA = qw(RestAuthResource);
our $prefix = '/users/';
sub new {
    my $class = shift;
    my $self = {
        _conn => shift,
        _name => shift,
    };

    bless $self, $class;        
    return $self;
}

sub exists {
    my $self = shift;
    my $resp = $self->request_get("$self->{_name}/");
    print 'resp: ', $resp, "\n";
}
1;
