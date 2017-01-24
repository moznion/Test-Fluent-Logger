package Test::Fluent::Logger;
use 5.008001;
use strict;
use warnings;
no warnings qw/redefine/;

our $VERSION = "0.01";

my $original__post = Fluent::Logger->can('_post');

my $is_active;
my @fluent_logs;

sub is_active {
    return $is_active;
}

sub import {
    activate();

    *Fluent::Logger::_post = sub {
        if ($is_active) {
            my ($self, $tag, $msg, $time) = @_;
            push @fluent_logs, {
                message    => $msg,
                time       => $time,
                tag_prefix => $self->tag_prefix || "",
            };
        } else {
            $original__post->(@_);
        }
    };
}

sub unimport {
    deactivate();
}

sub activate {
    $is_active = 1;
}

sub deactivate {
    $is_active = 0;
}

sub clear_fluent_logs {
    @fluent_logs = ();
}

sub get_fluent_logs {
    return @fluent_logs;
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::Fluent::Logger - It's new $module

=head1 SYNOPSIS

    use Test::Fluent::Logger;

=head1 DESCRIPTION

Test::Fluent::Logger is ...

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

