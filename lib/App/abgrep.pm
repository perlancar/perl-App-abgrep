## no critic: InputOutput::RequireBriefOpen

package App::abgrep;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

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
            'x.name.is_plural' => 1,
            'x.name.singular' => 'file',
            schema => ['array*', of=>'filename*'],
            pos => 1,
            greedy => 1,
        },
        # XXX recursive (-r)
    },
    output_code => sub {
        my %args = @_;
        my $files = $args{files};
        my ($fh, $file);

        unless (@$files) {
            $fh = \*STDIN;
        }

        $args{_source} = sub {
          READ_LINE:
            {
                if (!defined $fh) {
                    return unless @$files;
                    $file = shift @$files;
                    log_trace "Opening $file ...";
                    open $fh, "<", $file or do {
                        warn "abgrep: Can't open '$file': $!, skipped\n";
                        undef $fh;
                    };
                    redo READ_LINE;
                }

                my $line = <$fh>;
                if (defined $line) {
                    return ($line, $file);
                } else {
                    undef $fh;
                    redo READ_LINE;
                }
            }
        };

        AppBase::Grep::grep(%args);
    },
);

1;
# ABSTRACT:
