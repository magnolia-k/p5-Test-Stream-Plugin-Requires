package Test::Stream::Plugin::Requires;

use strict;
use warnings;

our $VERSION = '0.0.1';

use Test::Stream::Exporter;
default_exports qw/test_requires/;
no Test::Stream::Exporter;

use Test::Stream::Context qw/context/;

sub load_ts_plugin {
    my $class = shift;

    my ($caller, @args) = @_;

    Test::Stream::Exporter::export_from($class, $caller->[0], ['test_requires']);

    if (@args == 1 && ref $args[0] && ref $args[0] eq 'HASH' ) {
        while ( my ($mod, $ver) = each %{$args[0]} ) {
            test_requires($mod, $ver, $caller->[0]);
        }
    } else {
        for my $mod (@args) {
            test_requires($mod, undef, $caller->[0]);
        }
    }
}

sub test_requires {
    my ( $mod, $ver, $caller ) = @_;
    return if $mod eq __PACKAGE__;
    if (@_ != 3) {
        $caller = caller(0);
    }
    $ver ||= '';

    eval qq{package $caller; use $mod $ver}; ## no critic.

    my $ctx = context();

    my $e;
    my $skip_all;

    if ($e = $@) {
        $skip_all = sub {
            my $state = $ctx->hub->state;

            if (! $state->plan) {
                $ctx->plan(0, SKIP => @_);
            } else {
                for (1..$state->plan) {
                    $ctx->debug->set_skip(@_);
                    $ctx->ok(1, "skipped test");
                    $ctx->debug->set_skip(undef);
                }

                my $hub = Test::Stream::Sync->stack->top;
                if ($hub->can("nested")) {
                    die;
                }

                $ctx->release;
                exit 0;
            }
        };

        my $msg = "$e";
        if ( $e =~ /^Can't locate/ ) {
            $msg = "Test requires module '$mod' but it's not found";
        }

        if ($ENV{RELEASE_TESTING}) {
            my $ctx = context();
            $ctx->bail($msg);
        } else {
            $skip_all->($msg);
        }

    }
    
    $ctx->release;

    return 1;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Test::Stream::Plugin::Requires - Test::Requires for Test::Stream

=head1 SYNOPSIS

  use Test::Stream( "-V1", "Requires" );

  test_requires("JSON");

=cut
