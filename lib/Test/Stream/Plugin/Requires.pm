package Test::Stream::Plugin::Requires;

use strict;
use warnings;

our $VERSION = '0.0.1';

use Test::Stream::Exporter;
default_exports qw/test_requires/;
no Test::Stream::Exporter;

use Test::Stream::Context qw/context/;

use Carp qw/confess/;

sub test_requires {
    my ( $mod, $ver, $caller ) = @_;
    return if $mod eq __PACKAGE__;
    if (@_ != 3) {
        $caller = caller(0);
    }
    $ver ||= '';

    eval qq{package $caller; use $mod $ver}; ## no critic.

    my $e;
    my $skip_all;
    if ($e = $@) {
        $skip_all = sub {
            my $ctx = context();
            my $state = $ctx->hub->state;
            if (! $state->plan) {
                $ctx->plan(0, SKIP => @_);
            } elsif ($state->plan eq "no_plan") {
                $ctx->plan(0, SKIP => @_);
                
                my $stack = $ctx->stack;
                $ctx->release;
                if (@{$stack} >= 2) {
                    confess "Can't use test_requires in subtest!!";
                }

                exit 0;
            } else {
                for (1..$state->plan) {
                    $ctx->debug->set_skip(@_);
                    $ctx->ok(1, "skipped test");
                    $ctx->debug->set_skip(undef);
                }

                my $stack = $ctx->stack;
                $ctx->release;
                if (@{$stack} >= 2) {
                    confess "Can't use test_requires in subtest!!";
                }

                exit 0;
            }

        };
    }

    my $msg = "$e";
    if ( $e =~ /^Can't locate/ ) {
        $msg = "Test requires module '$mod' but it's not found";
    }

    $skip_all->($msg);

    return 1;
}

1;

__END__

=pod

=encoding UTF-8

=cut
