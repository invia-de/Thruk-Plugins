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

    use_ok 'Thruk::Controller::pnpmaptest';
};

my($host,$service) = TestUtils::get_test_service();
my $hostgroup      = TestUtils::get_test_hostgroup();
my $servicegroup   = TestUtils::get_test_servicegroup();

my $pages = [
    '/thruk/cgi-bin/pnpmaptest.cgi',
    '/thruk/cgi-bin/pnpmaptest.cgi?hostgroup=all',
    '/thruk/cgi-bin/pnpmaptest.cgi?hostgroup='.$hostgroup,
    '/thruk/cgi-bin/pnpmaptest.cgi?host=all',
    '/thruk/cgi-bin/pnpmaptest.cgi?host='.$host,
    '/thruk/cgi-bin/pnpmaptest.cgi?servicegroup='.$servicegroup,
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
    '/thruk/cgi-bin/pnpmaptest.cgi?style=hostdetail' => 'status\.cgi\?style=hostdetail',
    '/thruk/cgi-bin/status.cgi?style=pnpmaptest'     => 'pnpmaptest\.cgi\?style=pnpmaptest',
};
for my $url (keys %{$redirects}) {
    TestUtils::test_page(
        'url'      => $url,
        'location' => $redirects->{$url},
        'redirect' => 1,
    );
}
