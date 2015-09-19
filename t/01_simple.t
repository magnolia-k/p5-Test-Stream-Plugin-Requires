BEGIN { $ENV{RELEASE_TESTING} = 0 };
use Test::Stream("-V1", "Requires");

plan(10);

test_requires 'Acme::Unknown::Missing::Module::Name';

fail 'do not reach here';
