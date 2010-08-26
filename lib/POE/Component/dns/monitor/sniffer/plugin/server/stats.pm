package POE::Component::dns::monitor::sniffer::plugin::server::stats;

use strict;
use warnings;
use POE;
use DateTime;
use YAML;

sub spawn {
	my $self = shift;
	my %args = @_;

	die "Bad Config" if ref $args{Config} ne 'HASH';
	die "Bad Model" unless ref $args{DBICSchema};
	die "No Alias" unless length $args{Alias};

	my $sess = POE::Session->create( inline_states => {
		_start	=> sub { $poe_kernel->yield( 'server_stats_start', \%args ); },
		_stop 	=> sub { },
		server_stats_start => \&server_stats_start,
		process => \&process,
	});

	return $sess->ID;
}

sub server_stats_start {
	my($kernel,$heap,$args) = @_[KERNEL,HEAP,ARG0];

	$kernel->alias_set( $args->{Alias} );
	
	# Store stuff in the heap
	$heap->{log} = $args->{LogSID};
	$heap->{model} = $args->{DBICSchema};
}

sub process {
	my ( $kernel,$heap,$dnsp,$srv,$cli ) = @_[KERNEL,HEAP,ARG0,ARG1,ARG2];

	my $dt = DateTime->now();
	my $stats = $heap->{model}->resultset('server::stats')->find_or_create(
		{
			server_id	=> $srv->id,
			day 		=> $dt->ymd,
		}
	);	
	# Check for query/response
	if( $dnsp->header->qr ) {
		$stats->answers( $stats->answers + 1 );
	}
	else {
		$stats->questions( $stats->questions + 1 );
	}
	$stats->update;
}

# Return True
1;


