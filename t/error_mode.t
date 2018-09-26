use strict;
use warnings;

use Carp;
use File::Spec ();
use File::Slurp;
use File::Temp qw(tempfile);
use IO::Handle ();
use Test::More;

plan tests => 27;

my (undef, $file) = tempfile('tempXXXXX', DIR => File::Spec->tmpdir, OPEN => 0);

# read_file: error mode = croak
{
    my $res;
    my $warn;
    my $err = do { # catch
        local $@;
        local $SIG{__WARN__} = sub {$warn = join '', @_};
        eval { # try
            $res = read_file($file, err_mode => 'croak');
            1;
        };
        $@;
    };
    ok(!$warn, 'read_file: err_mode opt croak - no warn!');
    ok($err, 'read_file: err_mode opt croak - got exception!');
    ok(!$res, 'read_file: err_mode opt croak - no content!');
}

# read_dir: error mode = croak
{
    my $res;
    my $warn;
    my $err = do { # catch
        local $@;
        local $SIG{__WARN__} = sub {$warn = join '', @_};
        eval { # try
            $res = read_dir($file, err_mode => 'croak');
            1;
        };
        $@;
    };
    ok(!$warn, 'read_dir: err_mode opt croak - no warn!');
    ok($err, 'read_dir: err_mode opt croak - got exception!');
    ok(!$res, 'read_dir: err_mode opt croak - no content!');
}

# write_file: error mode = croak
{
    my $res;
    my $warn;
    my $err = do { # catch
        local $@;
        local $SIG{__WARN__} = sub {$warn = join '', @_};
        eval { # try
            $res = write_file(File::Spec->catfile($file,'foo','noexist.bar'), {err_mode => 'croak'}, 'junk');
            1;
        };
        $@;
    };
    ok(!$warn, 'write_file: err_mode opt croak - no warn!');
    ok($err, 'write_file: err_mode opt croak - got exception!');
    ok(!$res, 'write_file: err_mode opt croak - no return value');
}

# read_file: error mode = carp
{
    my $res;
    my $warn;
    my $err = do { # catch
        local $@;
        local $SIG{__WARN__} = sub {$warn = join '', @_};
        eval { # try
            $res = read_file($file, err_mode => 'carp');
            1;
        };
        $@;
    };
    ok($warn, 'read_file: err_mode opt carp - got warn!');
    ok(!$err, 'read_file: err_mode opt carp - no exception!');
    ok(!$res, 'read_file: err_mode opt carp - no content!');
}

# read_dir: error mode = carp
{
    my $res;
    my $warn;
    my $err = do { # catch
        local $@;
        local $SIG{__WARN__} = sub {$warn = join '', @_};
        eval { # try
            $res = read_dir($file, err_mode => 'carp');
            1;
        };
        $@;
    };
    ok($warn, 'read_dir: err_mode opt carp - got warn!');
    ok(!$err, 'read_dir: err_mode opt carp - no exception!');
    ok(!$res, 'read_dir: err_mode opt carp - no content!');
}

# write_file: error mode = carp
{
    my $res;
    my $warn;
    my $err = do { # catch
        local $@;
        local $SIG{__WARN__} = sub {$warn = join '', @_};
        eval { # try
            $res = write_file(File::Spec->catfile($file,'foo','noexist.bar'), {err_mode => 'carp'}, 'junk');
            1;
        };
        $@;
    };
    ok($warn, 'write_file: err_mode opt carp - got warn!');
    ok(!$err, 'write_file: err_mode opt carp - no exception!');
    ok(!$res, 'write_file: err_mode opt carp - no return value');
}

# read_file: error mode = quiet
{
    my $res;
    my $warn;
    my $err = do { # catch
        local $@;
        local $SIG{__WARN__} = sub {$warn = join '', @_};
        eval { # try
            $res = read_file($file, err_mode => 'quiet');
            1;
        };
        $@;
    };
    ok(!$warn, 'read_file: err_mode opt quiet - no warn!');
    ok(!$err, 'read_file: err_mode opt quiet - no exception!');
    ok(!$res, 'read_file: err_mode opt quiet - no content!');
}

# read_dir: error mode = quiet
{
    my $res;
    my $warn;
    my $err = do { # catch
        local $@;
        local $SIG{__WARN__} = sub {$warn = join '', @_};
        eval { # try
            $res = read_dir($file, err_mode => 'quiet');
            1;
        };
        $@;
    };
    ok(!$warn, 'read_dir: err_mode opt quiet - no warn!');
    ok(!$err, 'read_dir: err_mode opt quiet - no exception!');
    ok(!$res, 'read_dir: err_mode opt quiet - no content!');
}

# write_file: error mode = quiet
{
    my $res;
    my $warn;
    my $err = do { # catch
        local $@;
        local $SIG{__WARN__} = sub {$warn = join '', @_};
        eval { # try
            $res = write_file(File::Spec->catfile($file,'foo','noexist.bar'), {err_mode => 'quiet'}, 'junk');
            1;
        };
        $@;
    };
    ok(!$warn, 'write_file: err_mode opt quiet - got warn!');
    ok(!$err, 'write_file: err_mode opt quiet - no exception!');
    ok(!$res, 'write_file: err_mode opt quiet - no return value');
}

unlink($file);
