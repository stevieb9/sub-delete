#!perl
use 5.006;
use strict;
use warnings;

use Sub::Remove qw(sub_remove);

use Test::Exception;
use Test::More;

# Throws
{
    throws_ok
        { sub_remove() }
        qr/sub_remove\(\) requires a subroutine name/,
        "sub_remove() barfs if no parameters sent in ok";

    throws_ok
        { sub_remove('asdfasdf') }
        qr/Subroutine named 'main::asdfasdf' doesn't exist/,
        "sub_remove() barfs if sub name sent in doesn't exist ok";
}

# main sub
{
    like
        'main'->can('testing'),
        qr/^CODE/,
        "main::testing() exists ok";

    is testing(), 99, "...and it returns properly";

    sub_remove('testing');

    is
        'main'->can('testing'),
        undef,
        "sub_remove() removed main::testing() ok";

    throws_ok
        { testing() }
        qr/Undefined subroutine/,
        "...and it definitely can't be called";
}

sub testing {
    return 99;
}

done_testing();