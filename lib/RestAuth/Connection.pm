# This file is part of RestAuth.pm.
#
# RestAuth.pm is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RestAuth.pm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with RestAuth.pm.  If not, see <http://www.gnu.org/licenses/>.

package RestAuth::Connection;
use strict;
use warnings;

=head1 NAME

RestAuth::Connection - A connection to a RestAuth service

=head1 DESCRIPTION

An instance of this class represents a connection to a RestAuth service. If you
develop using this library, you usually never have to use any methods of this
class yourself besides providing an instance of this class to L<RestAuth::User>
or L<RestAuth::Group> instances. It is however possible to change authentication
credentials and the content-type used on the fly.

=head1 SYNOPSIS

    use RestAuth::Connection;
    use RestAuth::ContentHandler::Json;
    
    # Note that the JSON handler is used as default
    $conn = RestAuth::Connection->new(
        'https://auth.example.com', 'username', 'password');
    
    # set new credentials:
    $conn->set_credentials('new', 'password');
    
    # set a new content-handler
    $handler = RestAuth::ContentHandler::Json->new();
    $conn->set_content_handler($handler);

=head1 METHODS

=cut

use WWW::Curl::Share;
use HTTP::Response;
use MIME::Base64;

use RestAuth::Error::InternalServerError;
use RestAuth::ContentHandler::Json;

=head2 new($url, $username, $password, $content_type=undef)

The constructor for this class.

PARAMETERS:

=over

=item *

B<url> - string - The URL where the RestAuth service is available.

=item *

B<username> - string - The username used for authentication with RestAuth.

=item *

B<password> - string - The password used for authentication with RestAuth.

=item *

B<content_type> (optional) - L<RestAuth::ContentHandler> - Set to use a
different content type instead of the default C<application/json>.

=back

=cut
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

=head2 set_credentials($username, $password)

Set the credentials used by this connection.

PARAMETERS:

=over

=item *

B<username> - string - The username used for authentication with RestAuth.

=item *

B<password> - string - The password used for authentcation with RestAuth.

=back

=cut
sub set_credentials {
    my ($self, $user, $pass) = @_;
    $self->{_auth_header} = "Basic " . encode_base64("$user:$pass");
}

=head2 set_content_handler($content_handler)

Set a different content handler.

PARAMETERS:

=over

=item *

B<content_handler> - L<RestAuth::ContentHandler> - The new content handler to
use.

=back

=cut
sub set_content_handler {
    my $self = shift;
    $self->{_content_handler} = shift;
    
    if (! defined $self->{_content_handler}) {
        $self->{_content_handler} = new RestAuth::ContentHandler::Json();
    }
}

=head2 request($method, $path, $body=undef)

Do an actual HTTP request. This method takes care of setting necessary request
headers and authentication data, optionally encode a request body, parse the
HTTP response and throws some exceptions that may occur on all requests.

PARAMETERS:

=over

=item *

B<method> - string the HTTP method to perform. One of C<GET>, C<POST>, C<PUT>
or C<DELETE>.

=item *

B<path> - string - The URL path of the method.

=item *

B<body> (optional) - Hash - An unencoded HTTP body

=back

RETURNS:

=over

=item *

L<HTTP::Response|http://search.cpan.org/~gaas/HTTP-Message-6.03/lib/HTTP/Response.pm>
 - The response to the request.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub request {
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
        my $encoded_body = $self->{_content_handler}->encode_dict($body);
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

=head2 get($path)

Do an HTTP GET request.

PARAMETERS:

=over

=item *

B<path> - string - The path to do the GET request to.

=back

TODO:

=over

=item *

Support query parameters

=back

RETURNS:

=over

=item *

L<HTTP::Response|http://search.cpan.org/~gaas/HTTP-Message-6.03/lib/HTTP/Response.pm>
 - The response to the request.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub get {
    my ($self, $path) = @_;
    return $self->request('GET', $path);
}

=head2 post($path, $body)

Do an HTTP POST request.

PARAMETERS:

=over

=item *

B<path> - string - The path to do the GET request to.

=item *

B<body> - Hash - The (unencoded) HTTP body.

=back

RETURNS:

=over

=item *

L<HTTP::Response|http://search.cpan.org/~gaas/HTTP-Message-6.03/lib/HTTP/Response.pm>
 - The response to the request.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
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

=head2 put($path, $body)

Do an HTTP PUT request.

PARAMETERS:

=over

=item *

B<path> - string - The path to do the GET request to.

=item *

B<body> - Hash - The (unencoded) HTTP body.

=back

RETURNS:

=over

=item *

L<HTTP::Response|http://search.cpan.org/~gaas/HTTP-Message-6.03/lib/HTTP/Response.pm>
 - The response to the request.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
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

=head2 delete($path)

Do an HTTP DELETE request.

PARAMETERS:

=over

=item *

B<path> - string - The path to do the GET request to.

=back

RETURNS:

=over

=item *

L<HTTP::Response|http://search.cpan.org/~gaas/HTTP-Message-6.03/lib/HTTP/Response.pm>
 - The response to the request.

=back

THROWS:

=over

=item *

B<TODO>

=back

=cut
sub delete {
    my ($self, $path) = @_;
    return $self->request('DELETE', $path);
}

=head2 get_mime_type()

Shortcut to getting the MIME type currently used.

=cut
sub get_mime_type {
    my $self = shift;
    return $self->{_content_handler}->mime_type;
}

=head2 decode_list(\@raw)

Shortcut to the decode_list function of the current content handler.

=cut
sub decode_list {
    my ($self, $raw) = @_;
    return $self->{_content_handler}->decode_list($raw);
}

=head2 decode_dict(\%raw)

Shortcut to the decode_dict function of the current content handler.

=cut
sub decode_dict {
    my ($self, $raw) = @_;
    return $self->{_content_handler}->decode_dict($raw);
}

=head2 decode_str($raw)

Shortcut to the decode_str function of the current content handler.

=cut
sub decode_str {
    my ($self, $raw) = @_;
    return $self->{_content_handler}->decode_str($raw);
}

=head1 BUGS

To report bugs in this library please either join our RestAuth XMPP channel
found at restauth@conference.jabber.at or file an issue in L<our bugtracker
|https://redmine.fsinf.at/projects/restauth-perl>.

=head1 LICENSE

Copyright 2012, Mathias Ertl L<mati@restauth.net|mailto:mati@restauth.net>

This software is free. It is licensed under the
L<GNU General Public License, version 3|http://www.gnu.org/copyleft/gpl.html>.

The latest version of this software should be available via
L<our git repository|https://git.fsinf.at/restauth/perl> or via this projects
homepage, L<perl.restauth.net|https://perl.restauth.net>.

=cut

1;