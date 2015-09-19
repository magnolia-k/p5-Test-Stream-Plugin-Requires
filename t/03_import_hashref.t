BEGIN { $ENV{RELEASE_TESTING} = 0 };
use Test::Stream(
    "-V1", 
    "Requires" => [ {
        'Scalar::Util'                         => 0.02,
        'Acme::Unknown::Missing::Module::Name' => 0.01,
    } ]
);

fail 'do not reach here';

done_testing;
