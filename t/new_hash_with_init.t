use Test::More tests => 4;

package XXX;

use Class::MethodMaker::Util
    new_hash_with_init => 'new',
    get_set => [ qw/foo bar baz/ ];

sub init {
	my $self = shift;
	$self->bar(666);
	$self->baz(42);
}

package main;

# test the classes themselves

my $obj = XXX->new(foo => 7, bar => 13);
isa_ok($obj, 'XXX');
is($obj->foo,   7, 'foo()');
is($obj->bar, 666, 'bar()');
is($obj->baz,  42, 'baz()');
