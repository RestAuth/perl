package RestAuth::Error::Base;
use base qw(Error);
use overload ('""' => 'stringify');

sub new {
    my $self = shift;
    my $text = "" . shift;
    my @args = ();

    local $Error::Depth = $Error::Depth + 1;
    local $Error::Debug = 1;  # Enables storing of stacktrace

    $self->SUPER::new(-text => $text, @args);
}
1;

package RestAuth::Error::ConnectionError;
use base RestAuth::Error::Base;
1;

package RestAuth::Error::Http;
use base RestAuth::Error::Base;

sub new {
    my $self = shift;
    $self->{response} = shift;
    $self->SUPER::new($self->{response}->content);
}
1;

package RestAuth::Error::BadRequest;
use base RestAuth::Error::Http;
our $code = 400;
1;

package RestAuth::Error::Unauthorized;
use base RestAuth::Error::Http;
our $code = 401;
1;

package RestAuth::Error::Forbidden;
use base RestAuth::Error::Http;
our $code = 403;
1;

package RestAuth::Error::NotFound;
use base RestAuth::Error::Http;
our $code = 404;
1;

package RestAuth::Error::UserDoesNotExist;
use base RestAuth::Error::NotFound;
1;
package RestAuth::Error::GroupDoesNotExist;
use base RestAuth::Error::NotFound;
1;
package RestAuth::Error::PropertyDoesNotExist;
use base RestAuth::Error::NotFound;
1;

package RestAuth::Error::NotAcceptable;
use base RestAuth::Error::Http;
our $code = 406;
1;

package RestAuth::Error::Conflict;
use base RestAuth::Error::Http;
our $code = 409;
1;

package RestAuth::Error::UserExists;
use base RestAuth::Error::Conflict;
1;

package RestAuth::Error::GroupExists;
use base RestAuth::Error::Conflict;
1;

package RestAuth::Error::PropertyExists;
use base RestAuth::Error::Conflict;
1;

package RestAuth::Error::PreconditionFailed;
use base RestAuth::Error::Http;
our $code = 412;
1;

package RestAuth::Error::UnsupportedMediaType;
use base RestAuth::Error::Http;
our $code = 415;
1;

package RestAuth::Error::InternalServerError;
use base RestAuth::Error::Http;
our $code = 500;
1;

package RestAuth::Error::UnknownStatus;
use base RestAuth::Error::Http;
1;