package RestAuth;

use 5.006;
use strict;
use warnings;

=head1 NAME

RestAuth - The great new RestAuth!

=head1 VERSION

Version 0.5.1

=cut

our $VERSION = '0.5.0';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use RestAuth;

    my $foo = RestAuth->new();
    ...

=head1 Submodules

This library is devided into various submodules:

=over

=item *

L<RestAuth::Connection> representing a connection to a RestAuth service.

=item *

L<RestAuth::ContentHandler> Classes for content-handling.

=item *

L<RestAuth::Error> collects various errors.

=item *

L<RestAuth::User> is the main user object.

=back

=head1 AUTHOR

Mathias Ertl, C<< <mati at restauth.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-restauth at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=RestAuth>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc RestAuth


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=RestAuth>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/RestAuth>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/RestAuth>

=item * Search CPAN

L<http://search.cpan.org/dist/RestAuth/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Mathias Ertl.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; 
__END__
# End of RestAuth
