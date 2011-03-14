package Net::TCP::FindPort;
use strict;
use warnings;
our $VERSION = '1.0';
use Socket;

our $EphemeralStart = 1024;
our $EphemeralEnd = 5000;

our $UsedPorts = {};

sub is_listenable_port {
    my ($class, $port) = @_;
    return 0 unless $port;
    return 0 if $UsedPorts->{$port};
    
    my $proto = getprotobyname('tcp');
    socket(my $server, PF_INET, SOCK_STREAM, $proto) || die "socket: $!";
    setsockopt($server, SOL_SOCKET, SO_REUSEADDR, pack("l", 1)) || die "setsockopt: $!";
    bind($server, sockaddr_in($port, INADDR_ANY)) || return 0;
    listen($server, SOMAXCONN) || return 0;
    close($server);
    return 1;
}

sub find_listenable_port {
    my $class = shift;
    
    for (1..10000) {
        my $port = int rand($EphemeralEnd - $EphemeralStart);
        next if $UsedPorts->{$port};
        if ($class->is_listenable_port($port)) {
            $UsedPorts->{$port} = 1;
            return $port;
        }
    }

    die "Listenable port not found";
}

sub clear_cache {
    $UsedPorts = {};
}

1;
