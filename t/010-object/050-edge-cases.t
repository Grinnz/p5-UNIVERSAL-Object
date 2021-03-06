#!perl

use strict;
use warnings;

use Test::More qw[no_plan];

BEGIN {
    use_ok('UNIVERSAL::Object');
}

=pod

TODO:

=cut

{

    my $o = UNIVERSAL::Object->new;
    isa_ok($o, 'UNIVERSAL::Object');

    my $o2;

    $@ = undef;
    eval { $o2 = $o->new };
    ok(!$@, '... no expection calling ->new on instance');
    isnt($o, $o2, '... we got a new instance');
}

{
    package Foo;
    use strict;
    use warnings;

    our @ISA; BEGIN { @ISA = ('UNIVERSAL::Object') }
    our %HAS; BEGIN {
        %HAS = (
            test1 => sub { 'Foo::test1' },
            test2 => sub { 'Foo::test2' },
        )
    }

    sub test1 { $_[0]->{test1} }
    sub test2 { $_[0]->{test2} }
}

{

    foreach my $foo ( Foo->new, Foo->new({}) ) {
        isa_ok($foo, 'Foo');

        is($foo->test1, 'Foo::test1', '... no values yet');
        is($foo->test2, 'Foo::test2', '... no values yet');
    }

    foreach my $foo ( Foo->new( test1 => 10 ), Foo->new({ test1 => 10 }) ) {
        isa_ok($foo, 'Foo');

        is($foo->test1, 10, '... got value now');
        is($foo->test2, 'Foo::test2', '... no values yet');
    }

    foreach my $foo ( Foo->new( test1 => 10, test2 => 20 ), Foo->new({ test1 => 10, test2 => 20 }) ) {
        isa_ok($foo, 'Foo');

        is($foo->test1, 10, '... got value now');
        is($foo->test2, 20, '... got value now');
    }

}

{

    $@ = undef;
    eval { UNIVERSAL::Object->new([]) };
    like(
        $@,
        qr/^\[ARGS\] expected a HASH reference but got a ARRAY\(0x.*\)/,
        '... error case when incorrect type of args is passed in'
    );

    $@ = undef;
    eval { UNIVERSAL::Object->new(10) };
    like(
        $@,
        qr/^\[ARGS\] expected an even sized list reference but instead got 1 element\(s\)/,
        '... error case when incorrect number of args is passed in'
    );

}


