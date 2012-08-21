use strict;
BEGIN {
    my $file_name = __FILE__; $file_name =~ s{[^/\\]+$}{}; $file_name ||= '.';
    $file_name .= '/../config/perl/libs.txt';
    if (-f $file_name) {
        open my $file, '<', $file_name or die "$0: $file_name: $!";
        unshift @INC, split /:/, <$file>;
    }
}
use warnings;
use Test::X1;
use Test::More;
use Net::TCP::FindPort;

test {
    my $c = shift;
    ok !Net::TCP::FindPort->is_listenable_port(0);

    # A well-known port
    ok !Net::TCP::FindPort->is_listenable_port(70);
    done $c;
} n => 2, name => 'is_listenable_port ng';

test {
    my $c = shift;
    my $p1 = Net::TCP::FindPort->find_listenable_port;
    ok !Net::TCP::FindPort->is_listenable_port($p1);
    done $c;
} n => 1, name => 'is_listenable_port locked';

test {
    my $c = shift;
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
    done $c;
} n => 9, name => 'find_listenable_port';

run_tests;
