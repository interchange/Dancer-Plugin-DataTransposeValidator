package Dancer::Plugin::DataTransposeValidator;

use strict;
use warnings;

use Dancer ':syntax';
use Dancer::Plugin;
use aliased Dancer::Plugin::DataTransposeValidator::Validator;

=head1 NAME

Dancer::Plugin::DataTransposeValidator - Data::Transpose::Validator plugin for Dancer

=head1 VERSION

Version 0.001

=cut

our $VERSION = '0.001';

my $settings = plugin_setting;

register validator => sub {
    my ( $params, $rules_file ) = @_;

    Validator->new(
        params         => $params,
        plugin_setting => $settings,
        rules_file     => $rules_file
    )->transpose;
};

register_plugin;

1;
__END__

=head1 SYNOPSIS

    use Dancer::Plugin::DataTransposeValidator;

    post '/' => sub {
        my $params = params;
        my $data = validator($params, 'rules-file');
        if ( $data->{valid} ) { ... }
    }


=head1 DESCRIPTION

Dancer plugin for for L<Data::Transpose::Validator>

=head1 FUNCTIONS

This module exports the single function C<validator>.

=head2 validator( $params, $rules_file )

Arguments should be a hash reference of parameters to be validated and the
name of the rules file to use.

A hash reference with the following keys is returned:

=over 4

=item * valid

A boolean 1/0 showing whether the parameters validated correctly or not.

=item * values

The transposed values as a hash reference.

=item * errors

A hash reference containing one key for each parameter which failed validation.
See L</errors_hash> in L</CONFIGURATION> for an explanation of what the value
of each parameter key will be.

=item * css

A hash reference containing one key for each parameter which failed validation.
The value for each parameter is a css class. See L</css_error_class> in
L</CONFIGURATION>.

=back

=head2 RULES FILE

The rules file format allows the </validator> to be configured using
all options available in L<Data::Transpose::Validator>, for example:

    options => {
        stripwhite => 1,
        collapse_whitespace => 1,
        requireall => 0,
        unknown => fail,
        missing => undefine,
    },
    prepare => {
        email => {
            validator => "EmailValid",
            required => 1,
        },
        email2 => {
            validator => {
                class => "MyValidator::EmailValid",
                absolute => 1,
            }
        },
        field4 => {
            validator => {
                sub {
                    my $field = shift;
                    if ( $field =~ /^\d+/ && $field > 0 ) {
                        return 1;
                    }
                    else {
                        return ( undef, "Not a positive integer" );
                    }
                }
            }
        }
    }

Note that the value of the C<prepare> key must be a hash reference and the
array reference form of L<Data::Transpose::Validator/prepare> is not supported.

=head1 CONFIGURATION

The following configuration settings are available (defaults are
shown here):

    plugins:
      DataTransposeValidator:
        css_error_class: has-error
        errors_hash: 0
        rules_dir: validation

=head2 css_error_class

The class returned as a value for parameters in the css key of the hash
reference returned by L</validator>.

=head2 errors_hash

This can has a number of different values:

=over 4

=item * 0

A false value (the default) means that only a single scalar error string will
be returned for each parameter error. This will be the first error returned
for the paramater by L<Data::Transpose::Validator/errors_hash>.

=item * joined

All errors for a parameter will be returned joined by a full stop and a space.

=item * arrayref

All errors for a parameter will be returned as an array reference.

=back

=head2 rules_dir

Subdirectory of L<Dancer::Config/appdir> in which rules files are stored.


=head1 ACKNOWLEDGEMENTS

Alexey Kolganov for L<Dancer::Plugin::ValidateTiny> which inspired a number
of aspects of this plugin.

=head1 SEE ALSO

L<Dancer::Plugin::ValidateTiny> L<Dancer::Plugin::FormValidator>
L<Dancer::Plugin::DataFu>

=head1 AUTHOR

Peter Mottram (SysPete), C<< <peter@syxni.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2015 Peter Mottram (SysPete).

This program is free software; you can redistribute it and/or modify
it under the same terms as the Perl 5 programming language system itself.

=cut