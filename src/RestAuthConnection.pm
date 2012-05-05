package RestAuthConnection;
sub new {
    my $class = shift;
    my $self = {
        _testvar => shift,
    };

    bless $self, $class;
    return $self;
}

sub request {
    my $self = shift;
    print 'request';
}

sub get {
    my $self = shift;
    $self->request('foo');
}

sub post {
    my $self = shift;
}

sub put {
    my $self = shift;
}

sub delete {
    my $self = shift;
}
1;

package RestAuthResource;
sub new {
    my $class = shift;

    bless $self, $class;
    return $self;
}
