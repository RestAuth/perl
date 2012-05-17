PERL5LIB:= t:.:${PERL5LIB}

test:
	PERL5LIB=${PERL5LIB} /usr/share/perl5/Test/TestRunner.pl AllTests
