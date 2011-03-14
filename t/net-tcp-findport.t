package test::Net::TCP::FindPort;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->subdir('lib')->stringify;
use base qw(Test::Class);
use Test::More;
use Net::TCP::FindPort;

sub _is_listenable_port_ng : Test(2) {
    ok !Net::TCP::FindPort->is_listenable_port(0);

    # A well-known port
    ok !Net::TCP::FindPort->is_listenable_port(70);
}

sub _is_listenable_port_locked : Test(1) {
    my $p1 = Net::TCP::FindPort->find_listenable_port;
    ok !Net::TCP::FindPort->is_listenable_port($p1);
}

sub _find_listenable_port : Test(9) {
    my $p1 = Net::TCP::FindPort->find_listenable_port;
    ok $p1;
    ok $p1 > 1023;

    my $p2 = Net::TCP::FindPort->find_listenable_port;
    ok $p2;
    ok $p2 > 1023;
    isnt $p2, $p1;

    my $p3 = Net::TCP::FindPort->find_listenable_port;
    ok $p3;
    ok $p3 > 1023;
    isnt $p3, $p1;
    isnt $p3, $p2;
}

__PACKAGE__->runtests;

1;
