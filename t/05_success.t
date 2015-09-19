use Test::Stream( "-V1", "Requires" );

plan(1);

test_requires('Scalar::Util');
test_requires('Data::Dumper');
test_requires('Devel::Peek');

like Dumper("HOGE"), qr/\$VAR/;

