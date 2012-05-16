package RestAuthConnection;
use strict;
use warnings;

use WWW::Curl::Share;
use HTTP::Response;
use MIME::Base64;

use RestAuthError;
use RestAuthContentHandler;

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
    $self->{_content_handler} = shift;
    
    if (! defined $self->{_content_handler}) {
        $self->{_content_handler} = new RestAuthJsonContentHandler();
    }
}

sub get_mime_type {
    my $self = shift;
    return $self->{_content_handler}->mime_type;
}

sub request {
    # parameters:
    # * method
    # * path
    # * body (optional)
    my ($self, $method, $path, $body) = @_;
    my $response_body;
    my $curl = new WWW::Curl::Easy;
    
    my @headers = (
        "Accept: " . $self->get_mime_type,
    );
    
    # initialize CURL handler
    $curl->setopt(WWW::Curl::Share::CURLOPT_HEADER(), 1);
    $curl->setopt(WWW::Curl::Share::CURLOPT_TIMEOUT(), 2);
    $curl->setopt(WWW::Curl::Share::CURLOPT_URL(), $self->{_url} . $path);
    $curl->setopt(WWW::Curl::Share::CURLOPT_WRITEDATA(), \$response_body);
    $curl->setopt(WWW::Curl::Share::CURLOPT_CUSTOMREQUEST(), $method);
    
    if ($body) {
        my $encoded_body = $self->{_content_handler}->encode_array($body);
        $curl->setopt(WWW::Curl::Share::CURLOPT_POSTFIELDS(), $encoded_body);
        push(@headers, 'Content-type: ' . $self->get_mime_type);
    }
    
    # Add the autorization header.
    # WARNING: For some reason, this must be the *last* header in the list!
    push(@headers, "Authorization: $self->{_auth_header}");
    
    # set headers:
    $curl->setopt(WWW::Curl::Share::CURLOPT_HTTPHEADER(), \@headers);

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

sub get {
    my ($self, $path) = @_;
    return $self->request('GET', $path);
}

sub post {
    my ($self, $path, $body) = @_;
    return $self->request('POST', $path, $body);
}

sub put {
    my ($self, $path, $body) = @_;
    return $self->request('PUT', $path, $body);
}

sub delete {
    my ($self, $path) = @_;
    return $self->request('DELETE', $path);
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

sub request_post {
    my ($self, $path, $body) = shift;
    $path = $self->prefix . $path;
    
    #return $self->{_conn}->post($path, $body);
}

sub request_put {
    my ($self, $path, $body) = shift;
}

sub request_delete {
    my $self = shift;
    my $path = $self->prefix . shift;
    
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
