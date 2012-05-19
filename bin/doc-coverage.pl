#!/usr/bin/perl
use Pod::Coverage; 

sub coverage {
    my ($module) = @_;

    my $pc = Pod::Coverage->new(package => $module);
    print "$module: " . $pc->coverage . "\n";
    if ($pc->coverage != 1) {
        print join(', ', $pc->uncovered), "\n";
    }
}

coverage('RestAuth::Connection');
coverage('RestAuth::ContentHandler');
coverage('RestAuth::Error');
coverage('RestAuth::User');
coverage('RestAuth::Group');
