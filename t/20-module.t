#!perl
use 5.006;
use strict;
use warnings;

use Sub::Remove qw(sub_remove);

use Test::Exception;
use Test::More;

package Testing {
    sub function {
        return 100;
    }
};

package main {
    # Throws
    {
        throws_ok
            {sub_remove('asdfasdf', 'Testing')}
            qr/Subroutine named 'Testing::asdfasdf' doesn't exist/,
            "sub_remove() barfs if sub name sent in doesn't exist ok";
    }

    # Testing::function sub
    {
        like
            'Testing'->can('function'),
            qr/^CODE/,
            "Testing::function() exists ok";

        is Testing::function(), 100, "...and it returns properly";

        sub_remove('function', 'Testing');

        is
            'Testing'->can('function'),
            undef,
            "sub_remove() removed Testing::function() ok";

        throws_ok
            { Testing::function() }
            qr/Undefined subroutine/,
            "...and it definitely can't be called";
    }
}

done_testing();