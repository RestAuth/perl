use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'RestAuth.pm',
    AUTHOR              => q{Mathias Ertl <mati@restauth.net>},
    VERSION_FROM        => 'lib/Introduction.pod',
    ABSTRACT_FROM       => 'lib/Introduction.pod',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'gpl')
      : ()),
    PL_FILES            => {},
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Class' => 0,
        'Test::Deep' => 0,
    },
    PREREQ_PM => {
        'JSON' => 0,
        'WWW::Curl::Share' => 0,
        'HTTP::Response' => 0,
        'MIME::Base64' => 0,
        'Error' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'RestAuth-*' },
);
