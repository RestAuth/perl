package RestAuthConnection;
use strict;
use warnings;
use WWW::Curl::Share;
use HTTP::Response;
use MIME::Base64;
use RestAuthError;

sub new {
    my $class = shift;
    my $self = {
        _url => shift,
    };
    bless $self, $class;

    $self->set_credentials(shift, shift);
    $self->set_content_handler(shift);

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
    my $curl = shift;
    my $path = shift;
    my $response_body;
    
    #TODO: use correct content-type header
    my @headers = (
        "Authorization: $self->{_auth_header}",
        "Accept: $self->{_mime}",
    );

    $curl->setopt(WWW::Curl::Share::CURLOPT_URL(), $self->{_url} . $path);
    $curl->setopt(WWW::Curl::Share::CURLOPT_WRITEDATA(), \$response_body);
    $curl->setopt(WWW::Curl::Share::CURLOPT_HTTPHEADER(), \@headers, 1);

    my $retcode = $curl->perform;
    if ($retcode == 0) {
        my $response = HTTP::Response->parse($response_body);
        if ($response->code == 500) {
            throw RestAuthInternalServerError($response);
        } elsif ($response->code == 401) {
            throw RestAuthUnauthorized($response);
        } elsif ($response->code == 403) {
            throw RestAuthForbidden($response);
        } else {
            return $response;
        }
    } else {
        throw RestAuthConnectionError($curl);
    }
}

sub curl_handler {
    my $self = shift;

    my $curl = new WWW::Curl::Easy;
    $curl->setopt(WWW::Curl::Share::CURLOPT_HEADER(), 1);
    $curl->setopt(WWW::Curl::Share::CURLOPT_TIMEOUT(), 2);
    return $curl;
}

sub get {
    my $self = shift;
    my $path = shift;
    my $curl = $self->curl_handler;
    
    my $response = $self->request($curl, $path);
    return $response;
}

sub post {
    my $self = shift;
    my $path = shift;
    
    my $curl = $self->curl_handler;
    my $response = $self->request($curl, $path);
    return $response;
}

sub put {
    my $self = shift;
    my $path = shift;
    my $curl = $self->curl_handler;
    my $response = $self->request($curl, $path);
    return $response;
}

sub delete {
    my $self = shift;
    my $path = shift;
    my $curl = $self->curl_handler;
    my $response = $self->request($curl, $path);
    return $response;
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
