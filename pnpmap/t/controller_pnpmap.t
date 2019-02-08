use strict;
use warnings;
use Test::More tests => 92;

BEGIN {
    use lib('t');
    require TestUtils;
    import TestUtils;
}

SKIP: {
    skip 'external tests', 1 if defined $ENV{'CATALYST_SERVER'};

    use_ok 'Thruk::Controller::pnpmap';
};

my($host,$service) = TestUtils::get_test_service();
my $hostgroup      = TestUtils::get_test_hostgroup();
my $servicegroup   = TestUtils::get_test_servicegroup();

my $pages = [
    '/thruk/cgi-bin/pnpmap.cgi',
    '/thruk/cgi-bin/pnpmap.cgi?hostgroup=all',
    '/thruk/cgi-bin/pnpmap.cgi?hostgroup='.$hostgroup,
    '/thruk/cgi-bin/pnpmap.cgi?host=all',
    '/thruk/cgi-bin/pnpmap.cgi?host='.$host,
    '/thruk/cgi-bin/pnpmap.cgi?servicegroup='.$servicegroup,
];

for my $url (@{$pages}) {
    TestUtils::test_page(
        'url'     => $url,
        'like'    => [ 'PNP Map', 'statusTitle' ],
        'unlike'  => [ 'internal server error', 'HASH', 'ARRAY' ],
    );
}


# redirects
my $redirects = {
    '/thruk/cgi-bin/pnpmap.cgi?style=hostdetail' => 'status\.cgi\?style=hostdetail',
    '/thruk/cgi-bin/status.cgi?style=pnpmap'     => 'pnpmap\.cgi\?style=pnpmap',
};
for my $url (keys %{$redirects}) {
    TestUtils::test_page(
        'url'      => $url,
        'location' => $redirects->{$url},
        'redirect' => 1,
    );
}
