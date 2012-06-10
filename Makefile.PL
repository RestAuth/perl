use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'RestAuth',
    AUTHOR              => q{Mathias Ertl <mati@restauth.net>},
    VERSION_FROM        => 'lib/Introduction.pod',
    ABSTRACT_FROM       => 'lib/Introduction.pod',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Test::Class' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'RestAuth-*' },
);
