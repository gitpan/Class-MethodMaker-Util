use Test::More tests => 8;

package XXX;

use Class::MethodMaker::Util
    singleton => 'instance',
    get_set => [ qw/foo bar baz/ ];

sub init {
	my $self = shift;
	$self->bar(666);
	$self->baz(42);
}

package main;

# test the classes themselves

my $obj = XXX->instance(foo => 7, bar => 13);
isa_ok($obj, 'XXX');
is($obj->foo,   7, 'foo()');
is($obj->bar, 666, 'bar()');
is($obj->baz,  42, 'baz()');

my $obj2 = XXX->instance;
isa_ok($obj2, 'XXX');
is($obj2->foo,   7, 'foo()');
is($obj2->bar, 666, 'bar()');
is($obj2->baz,  42, 'baz()');
