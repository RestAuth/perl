package RestAuthConnection;
use strict;
use warnings;
use WWW::Curl::Simple;
require HTTP::Request;
use MIME::Base64;

sub new {
    my $class = shift;
    my $self = {
        _url => shift,
    };
    bless $self, $class;

    $self->set_credentials(shift, shift);
    $self->set_content_handler(shift);

    #TODO: useful?
    #$self->{_curlsh} = new WWW::Curl::Share;

    return $self;
}

sub set_credentials {
    my $self = shift;
    $self->{_user} = shift;
    $self->{_pass} = shift;

    my $encoded = encode_base64("$self->{_user}:$self->{_pass}");
    $self->{_auth_header} = "Basic $encoded";
}

sub set_content_handler {
    my $self = shift;
    $self->{_mime} = shift;
}

sub request {
    # parameters:
    # * curl handler
    # * path
    my $self = shift;
    my $req = shift;

    my $curl = WWW::Curl::Simple->new();

    $req->header('Authorization' => $self->{_auth_header});
    $req->header(       'Accept' => $self->{_mime});

    my $resp = $curl->request($req);
    return $resp;
}

sub get {
    my $self = shift;
    my $path = shift;

    my $req = HTTP::Request->new(GET => $self->{_url} . $path);
    return $self->request($req);
}

sub post {
    my $self = shift;
    my $path = shift;
}

sub put {
    my $self = shift;
    my $path = shift;
}

sub delete {
    my $self = shift;
    my $path = shift;
}
1;

package RestAuthContentHandler;
1;

package RestAuthResource;
sub new {
    my $class = shift;
    my $self = {
        _conn => shift,
    };

    bless $self, $class;
    return $self;
}

sub request_get {
    my $self = shift;
    my $path = $self->prefix . shift;
    
    return $self->{_conn}->get($path);
}

sub prefix {
    my $self = shift;
    my $class = ref($self) || $self;
    my $varname = $class . "::prefix";
    no strict 'refs';
    return $$varname;
}

1;
