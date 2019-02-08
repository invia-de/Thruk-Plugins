package Thruk::Controller::pnpmaptest;

use strict;
use warnings;
#use Data::Dumper;

=head1 NAME

Thruk::Controller::pnpmaptest - Thruk Controller

=head1 DESCRIPTION

Thruk Controller.

=head1 METHODS

=cut

##########################################################

=head2 index

pnpmaptest index page

=cut
sub index {
    my ( $c ) = @_;

    return unless Thruk::Action::AddDefaults::add_defaults($c, Thruk::ADD_DEFAULTS);

    # set some defaults
    Thruk::Utils::Status::set_default_stash($c);

    my $style = $c->req->parameters->{'style'} || 'pnpmaptest';
    if($style ne 'pnpmap') {
        return if Thruk::Utils::Status::redirect_view($c, $style);
    }

    # do the filter
    my( $hostfilter, $servicefilter, $groupfilter ) = Thruk::Utils::Status::do_filter($c);
    return if $c->stash->{'has_error'};

    my($uniq_services, $hosts, $matrix) = Thruk::Utils::Status::get_service_matrix($c, $hostfilter, $servicefilter);
    $c->stash->{services}     = $uniq_services;
    $c->stash->{hostnames}    = $hosts;
    $c->stash->{matrix}       = $matrix;

    my $longest_service = 1;
    for my $s (keys %{$uniq_services}) {
	my $len = length $s;
	$longest_service = $len if $len > $longest_service;
    }

    $c->stash->{head_height}	= 7*$longest_service;
    $c->stash->{style}		= 'pnpmaptest';
    $c->stash->{substyle}	= 'service';
    $c->stash->{title}		= 'PNP Map (Dev)';
    $c->stash->{show_top_pane}	= 1;
    $c->stash->{page}		= 'status';
    $c->stash->{template}	= 'pnpmaptest.tt';
    $c->stash->{infoBoxTitle}	= 'PNP Map';
#open(my $ftmp, "> /tmp/thruktmp");
#print $ftmp Data::Dumper::Dumper($c->stash->{matrix});
#close($ftmp);
    Thruk::Utils::ssi_include($c);

    Thruk::Utils::Status::set_custom_title($c);

    return 1;
}


=head1 AUTHOR

Sven Nierlein, 2009-present, <sven@nierlein.org>
Ronny Lindner, 2012-present, <ronny.lindner@invia.de>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
