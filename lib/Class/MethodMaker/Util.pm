package Class::MethodMaker::Util;

require 5.005_62;
use strict;
use warnings;
use base 'Class::MethodMaker';

our $VERSION = '1.00';

sub singleton {
	my ($self, @args) = @_;
	my %methods;
	foreach (@args) {
		$methods{$_} = sub {
            our $singleton;
            return $singleton if defined $singleton;

            my $class = shift;
            $singleton = ref ($class) ? $class : bless {}, $class;
            my %args = (scalar @_ == 1 and ref($_[0]) eq 'HASH')
                 ? %{ $_[0] } : @_;
            $singleton->$_($args{$_}) for keys %args;
            $singleton->init(%args);
            $singleton;
		};
	}
	$self->install_methods(%methods);
}

sub new_hash_with_init {
	my ($self, @args) = @_;
	my %methods;
	foreach (@args) {
		$methods{$_} = sub {
            my $class = shift;
            my $self = ref ($class) ? $class : bless {}, $class;
            my %args = (scalar @_ == 1 and ref($_[0]) eq 'HASH')
                 ? %{ $_[0] } : @_;
            $self->$_($args{$_}) for keys %args;
            $self->init(%args);
            $self;
		};
	}
	$self->install_methods(%methods);
}

1;

__END__

=head1 NAME

Class::MethodMaker::Util - New constructor and accessor types for Class::MethodMaker

=head1 SYNOPSIS

  package Log;
  use Class::MethodMaker::Util
    singleton => 'instance',
    get_set   => 'filename';

  package main;
  my $log = Log->instance(filename => '/tmp/foo.log');
  ...
  my $log2 = Log->instance;
  print $log2->filename;     # prints '/tmp/foo.log'

or

  use Class::MethodMaker::Util
    new_hash_with_init => 'new',
    get_set            => [ qw/foo bar baz/ ];

  sub init {
     my $self = shift;
     $self->SUPER::init(@_);
     # provide defaults
     $self->bar(66) unless defined $self->bar;
     $self->baz('flurble') unless defined $self->baz;
  }

=head1 DESCRIPTION

This module extends L<Class::MethodMaker> with new method types for
generating constructors and accessors. It subclasses L<Class::MethodMaker>
and thus supports all of that module's method types as well.

=head1 SUPPORTED METHOD TYPES

=head2 C<new_hash_with_init>

Creates a constructor which, like L<Class::MethodMaker>'s
C<new_hash_init>, accepts a hash of slot-name/value pairs with which
to initialize the object. The slot-names are interpreted as the names
of methods that can be called on the object after it is created and the
values are the arguments to be passed to those methods. Additionally, like
L<Class::MethodMaker>'s C<new_with_init>, it afterwards calls C<init()>
on that object propagating all arguments, before returning the object.

Takes a single string or a reference to an array of strings as its
argument.  For each string creates a simple method that creates and
returns an object of the appropriate class.

This method may be called as a class method, as usual, or as in instance
method, in which case a new object of the same class as the instance
will be created.

=head2 C<singleton>

Like C<new_with_hash_init>, except that it creates a constructor for a
singleton class, which is an class that should only have one instance
throughout an application. One example for a singleton class would be
a centralized logger or spooler. The first time the method is called,
the singleton instance is created. Calling the method afterwards returns
that same object.

=head1 BUGS

If you find any bugs or oddities, please do inform the author.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 VERSION

This document describes version 1.00 of C<Class::MethodMaker::Util>.

=head1 AUTHOR

Marcel GrE<uuml>nauer <marcel@cpan.org>

=head1 CONTRIBUTORS

Florian Helmberger <florian@cpan.org>

=head1 COPYRIGHT

Copyright 2001-2003 Marcel GrE<uuml>nauer. All rights reserved.

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

L<Class::MethodMaker>

=cut
