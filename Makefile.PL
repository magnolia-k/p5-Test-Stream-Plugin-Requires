use 5.006;

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Test-Stream-Plugin-Requires',
    AUTHOR           => q{Magnolia.K <magnolia.k@icloud.com>},
    VERSION_FROM     => 'lib/Test/Stream/Plugin/Requires.pm',
    ABSTRACT_FROM    => 'lib/Test/Stream/Plugin/Requires.pm',
    LICENSE          => 'perl',
    MIN_PERL_VERSION => 5.008001,

    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 6.66,
    },
    BUILD_REQUIRES => {
        'ExtUtils::MakeMaker' => 6.66,
    },

    PREREQ_PM       => {
        'Test::Stream' => 0,
    },

    META_MERGE      => {
        "meta-spec" => { version => 2 },

        "resources" => {
            "homepage" => "https://github.com/magnolia-k/p5-Test-Stream-Plugin-Requires",

            "bugtracker" => {
                "web" => "https://github.com/magnolia-k/p5-Test-Stream-Plugin-Requires/issues",
            },

            "repository" => {
                "type" => "git",
                "url"  => "https://github.com/magnolia-k/p5-Test-Stream-Plugin-Requires.git",
                "web"  => "https://github.com/magnolia-k/p5-Test-Stream-Plugin-Requires",
            },
        },
    },

    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Test-Stream-Plugin-Requires-*' },
)
