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

package RestAuth::Connection;
use strict;
use warnings;

use WWW::Curl::Share;
use HTTP::Response;
use MIME::Base64;

use RestAuth::Error;
use RestAuth::ContentHandler;

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
    my ($self, $user, $pass) = @_;
    $self->{_auth_header} = "Basic " . encode_base64("$user:$pass");
}

sub set_content_handler {
    my $self = shift;
    $self->{_content_handler} = shift;
    
    if (! defined $self->{_content_handler}) {
        $self->{_content_handler} = new RestAuth::JsonContentHandler();
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
        
        push(@headers, 'Content-Type: ' . $self->get_mime_type);
        # NOTE: The +2 is a magic value, otherwise the body is cropped
        #       on the server-side.
        push(@headers, 'Content-Length: ' . (length($encoded_body) + 2));
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
            throw RestAuth::Error::InternalServerError($response);
        } elsif ($response->code == 401) {
            throw RestAuth::Error::Unauthorized($response);
        } elsif ($response->code == 403) {
            throw RestAuth::Error::Forbidden($response);
        } elsif ($response->code == 406) {
            throw RestAuth::Error::NotAcceptable($response);
        } else {
            return $response;
        }
    } else {
        throw RestAuth::Error::ConnectionError($curl);
    }
}

sub get {
    my ($self, $path) = @_;
    return $self->request('GET', $path);
}

sub post {
    my ($self, $path, $body) = @_;
    my $response = $self->request('POST', $path, $body);
    
    if ($response->code == 400) {
        throw RestAuth::Error::BadRequest($response);
    } elsif ($response->code == 415) {
        throw RestAuth::Error::UnsupportedMediaType($response);
    } else {
        return $response;
    }
}

sub put {
    my ($self, $path, $body) = @_;
    my $response = $self->request('PUT', $path, $body);
    
    if ($response->code == 400) {
        throw RestAuth::Error::BadRequest($response);
    } elsif ($response->code == 415) {
        throw RestAuth::Error::UnsupportedMediaType($response);
    } else {
        return $response;
    }
}

sub delete {
    my ($self, $path) = @_;
    return $self->request('DELETE', $path);
}

sub decode_list {
    my ($self, $raw) = @_;
    return $self->{_content_handler}->decode_list($raw);
}
sub decode_dict {
    my ($self, $raw) = @_;
    return $self->{_content_handler}->decode_dict($raw);
}

1;

package RestAuth::Resource;

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
