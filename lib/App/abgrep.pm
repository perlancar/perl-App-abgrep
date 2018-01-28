package App::abgrep;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use AppBase::Grep;
use Perinci::Sub::Util qw(gen_modified_sub);

our %SPEC;

gen_modified_sub(
    output_name => 'abgrep',
    base_name   => 'AppBase::Grep::grep',
    summary     => 'Print lines matching a pattern',
    description => <<'_',

This is a grep-like utility that is based on <pm:AppBase::Grep>, mainly for
demoing and testing the module.

_
    add_args    => {
        files => {
            schema => ['array*', of=>'filename*'],
            cmdline_src => 'stdin_or_files',
            pos => 1,
            greedy => 1,
        },
        # XXX recursive (-r)
    },
    output_code => sub {
        my %args = @_;
        $args{_source} = sub {
            if (defined(my $line = <>)) {
                return ($line, $ARGV);
            } else {
                return;
            }
        };

        AppBase::Grep::grep(%args);
    },
);

1;
# ABSTRACT:
