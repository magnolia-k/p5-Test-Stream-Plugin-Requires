BEGIN { $ENV{RELEASE_TESTING} = 0 };
use Test::Stream( "-V1", "Requires" );

plan(4);

test_requires '5.005';
test_requires 'v5.5';
pass 'should reach here';

unless ($] > 5.998) {
    test_requires '5.999';
    fail 'do not reach here';
}
