package RestAuthConnection;
use strict;
use warnings;
use WWW::Curl::Share;
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
    my $curl = shift;
    my $path = shift;
    
    $curl->setopt(WWW::Curl::Share::CURLOPT_URL(), $self->{_url} . $path);

    #TODO: use correct content-type header
    my @headers = (
        "Authorization: $self->{_auth_header}",
        "Accept: $self->{_mime}",
    );

    $curl->setopt(WWW::Curl::Share::CURLOPT_HTTPHEADER(), \@headers, 1);

    my $retcode = $curl->perform;
    if ($retcode == 0) {
        my $response_code = $curl->getinfo(WWW::Curl::Share::CURLINFO_HTTP_CODE());
        if ($response_code == 500) {
            print("Internal Server Error");
        } elsif ($response_code == 401) {
            print("Not authorized");
        } else {
            print("OK");
        }
    } else {
        print("An error happened: $retcode " . $curl->strerror($retcode)." " . $curl->errbuf."\n");
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
    my $response_code = $curl->getinfo(WWW::Curl::Share::CURLINFO_HTTP_CODE());
    return $curl;
}

sub post {
    my $self = shift;
    my $path = shift;
    
    my $curl = $self->curl_handler;
    $self->request($curl);
    return $curl;
}

sub put {
    my $self = shift;
    my $curl = $self->curl_handler;
    my $path = shift;
    return $curl;
}

sub delete {
    my $self = shift;
    my $curl = $self->curl_handler;
    my $path = shift;
    return $curl;
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
    print $$varname, "\n";
    return $$varname;
}

1;
