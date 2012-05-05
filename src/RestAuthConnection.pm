package RestAuthConnection;
use strict;
use warnings;
use WWW::Curl::Share;

sub new {
    my $class = shift;
    my $self = {
        _url => shift,
        _path => shift,
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
    $self->{_auth_header} = 'Basic XXXX';
}

sub set_content_handler {
    my $self = shift;
}

sub request {
    # parameters:
    # * curl handler
    # * headers
    my $self = shift;
    my $curl = shift;

    #TODO: use correct content-type header
    my @headers = (
        "Authorization: $self->{_auth_header}",
        'Accept: application/json',
    );

    $curl->setopt(WWW::Curl::Share::CURLOPT_HTTPHEADER(), \@headers, 1);

    my $retcode = $curl->perform;
    if ($retcode == 0) {
        my $response_code = $curl->getinfo(WWW::Curl::Share::CURLINFO_HTTP_CODE());
        print("Response code: $response_code");
#        print("Received response: $response_body\n");
    } else {
        print("An error happened: $retcode " . $curl->strerror($retcode)." " . $curl->errbuf."\n");
    }
    print 'request';
}

sub curl_handler {
    my $self = shift;

    my $curl = new WWW::Curl::Easy;
    $curl->setopt(WWW::Curl::Share::CURLOPT_HEADER(), 1);
    $curl->setopt(WWW::Curl::Share::CURLOPT_URL(), $self->{_url});
    $curl->setopt(WWW::Curl::Share::CURLOPT_TIMEOUT(), 2);
    return $curl;
}

sub get {
    my $self = shift;
    my @headers = ('foo', 'bar');
    my $curl = $self->curl_handler;
    
    #print $headers, "\n";
    my $response = $self->request($curl, @headers);
}

sub post {
    my $self = shift;
    my $headers = $self->get_headers;
    
    my $curl = $self->curl_handler;
    $self->request($curl);
}

sub put {
    my $self = shift;
}

sub delete {
    my $self = shift;
}
1;

package RestAuthContentHandler;
1;

package RestAuthResource;
sub new {
    my $class = shift;
    my $self = {};

    bless $self, $class;
    return $self;
}
1;
