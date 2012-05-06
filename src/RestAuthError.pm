package RestAuthError;
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

package RestAuthConnectionError;
use base RestAuthError;
1;

package RestAuthHttpError;
use base RestAuthError;

sub new {
    my $self = shift;
    $self->{response} = shift;
    $self->SUPER::new($self->{response}->content);
}
1;

package RestAuthBadRequest;
use base RestAuthHttpError;
our $code = 400;
1;

package RestAuthUnauthorized;
use base RestAuthHttpError;
our $code = 401;
1;

package RestAuthForbidden;
use base RestAuthHttpError;
our $code = 403;
1;

package RestAuthNotFound;
use base RestAuthHttpError;
our $code = 404;
1;

package RestAuthInternalServerError;
use base RestAuthHttpError;
our $code = 500;
1;

package RestAuthUnknownStatus;
use base RestAuthHttpError;
1;
