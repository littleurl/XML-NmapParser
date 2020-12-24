# -------------------------------
package XML::NmapParser::Host;


our $VERSION = "0.2.2 a";

use strict;
use warnings;
use Carp; 
use Exporter;
use parent 'XML::NmapParser';

my @ISA = qw(XML::NmapParser::Host Exporter);

use vars qw($AUTOLOAD);


sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;

    $self->SUPER::initialize(shift, shift);
    $self->{Host} = $self->{stem};
    return $self;
}

# passed
sub initialize {
    my $self = shift;
    $self->SUPER::initialize(shift, shift);
    $self->{Host} = shift;
}



# passed
sub hostname { 
	my ($self,$index) = @_;
	if (! defined($index)) { $index=0; }
	
	return ( ${$self->{Host}{hostname}}[$index]{name} );		
}

sub uptime_lastboot { 
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{uptime}{lastboot})) { $returnValue = $self->{Host}{uptime}{lastboot}; } 
	return $returnValue;	
}

sub uptime_seconds { 
	my ($self) = @_;
	my $returnValue = undef;
#	$self->{Host}{status}{state}
	if ( defined($self->{Host}{uptime}{seconds})) { $returnValue = $self->{Host}{uptime}{seconds}; } 
	return $returnValue;	
}



#passed
sub all_hostnames { 
	my ($self) = @_;
	my @names;
	foreach ( @{$self->{Host}{hostname}}) { 
		push(@names,$_->{name});
	}	
	return @names; 
}


#passed
sub extraports_count {	
	my ($self,$state) = @_;
	my $count = 0;
	foreach ( @{$self->{Host}{extraports}}) {
		if ( ! defined($state)) {
			$count += $_->{count}; 
		} 	
	}	
	return $count; 
}

sub extraports_state { 
	my ($self,$index) = @_;
	my $returnValue = undef;
	if (defined($index)) { $returnValue = $self->{Host}{extraports}[$index]{state};
	} else { $returnValue = $self->{Host}{extraports}[0]{state}; }
	return $returnValue;	
}


sub trace_port { }
sub trace_error { }


sub traceroute { 
	my ($self) = @_;
	my @traceoute; 
	if ( defined($self->{stem}{traceroute})) {
		if ( ref($self->{stem}{traceroute}{hop}) eq "ARRAY") { 
			foreach ( @{$self->{stem}{traceroute}{hop}}) { 
				push(@traceoute,$_);
			}
		} elsif ( ref($self->{stem}{traceroute}{hop}) eq "HASH") { 
			push(@traceoute,$self->{stem}{traceroute}{hop});
		} 
	} 

	return @traceoute; 

} 

sub all_trace_hops { 
	use XML::NmapParser::Host::TraceHop; 
	
	my ($self) = @_;
	my @hops; 
	if ( defined($self->{stem}{traceroute})) {
		if ( ref($self->{stem}{traceroute}{hop}) eq "ARRAY") { 
			foreach ( @{$self->{stem}{traceroute}{hop}}) { 
                		my $trace = XML::NmapParser::Host::TraceHop->new($_);
				push(@hops,$trace);
			}
		} elsif ( ref($self->{stem}{traceroute}{hop}) eq "HASH") { 
                	my $trace = XML::NmapParser::Host::TraceHop->new($_);
			push(@hops, $self->{stem}{traceroute}{hop});
		} 
#		else { die "WTF!!!! \n";}
	}  
	
	return @hops; 
}


sub os_sig  { 
	use XML::NmapParser::Host::OS; 
	my ($self) = @_;
	my $OS = XML::NmapParser::Host::OS->new($self->{Host}{os});
	
	return $OS; 
}

sub portscripts { 
	use XML::NmapParser::Host::Script; 
	
	my ($self,$port) = @_;
	my @returnValue;
  
	foreach ( @{$self->{Host}{ports}}) {
		if ( $_->{portid} eq $port ) {
			if ( $_->{scripts} ) {
				for my $script ( @{$_->{scripts}}) {
					my $SCRIPT = XML::NmapParser::Host::Script->new($script);
					push(@returnValue, $SCRIPT); 
				}
			} 
		}
	}
		
	return @returnValue;
	
	
}

# passed
sub hostscripts { 
	use XML::NmapParser::Host::Script; 
	
	my ($self,$name) = @_;
	my @returnValue;
	my $SCRIPT;  
	foreach ( @{$self->{Host}{hostscript}{scripts}} ) { 
		if ( defined($name)) { 
			if ( $name eq $_->{id} ) { 
				push(@returnValue,$_->{output});
			}
			push(@returnValue, { %{$_->{elem}}});
		} else {
			my $SCRIPT = XML::NmapParser::Host::Script->new($_);
			push(@returnValue,$SCRIPT);
			# push(@returnValue,$_->{id});
		}	
	}
	return @returnValue;
}




sub trace_proto { 
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{trace}{proto})) { $returnValue = $self->{Host}{trace}{proto}; } 
	return $returnValue;		
}


sub tcp_service {
	use XML::NmapParser::Host::Service; 
	 
	my ($self,$port) = @_;
	my $service = undef;
	foreach ( @{$self->{Host}{ports}}) { 
		if ( ($_->{portid} eq $port) && ($_->{protocol} eq "tcp" ) ) { $service = $_; }
	}
		
	my $SERVICE = XML::NmapParser::Host::Service->new($service); 
	return $SERVICE; 
}

sub udp_service {
	use XML::NmapParser::Host::Service;  
	
	my ($self,$port) = @_;
	my $service = undef;
	foreach ( @{$self->{Host}{ports}}) { 
		if ( ($_->{portid} eq $port) && ($_->{protocol} eq "udp" ) ) { $service = $_; }
	}

	my $SERVICE = XML::NmapParser::Host::Service->new($service); 
	return $SERVICE; 

}



sub mac_vendor { 
	my ($self) = @_;
	my  $macVendor = undef;
	
	if ( ref($self->{Host}{address}) eq "ARRAY") {
		foreach (@{$self->{Host}{address}}) { if ( $_->{addrtype} eq "mac" ) { $macVendor = $_->{vendor}; } } 
	} elsif (ref($self->{Host}{address}) eq "hash") {
		if ( $self->{Host}{address}{addrtype} eq "mac" ) { $macVendor = $self->{Host}{address}{vendor}} 
	} 
	return $macVendor;
}

sub mac_addr { 
	my ($self) = @_;
	my  $MAC = getAddrValue($self,'mac'); 	
	return $MAC;	
}

sub ipv4_addr { 
	my ($self) = @_;
	my  $IPv4 = getAddrValue($self,'ipv4'); 	
	return $IPv4;
}

sub ipv6_addr { 
	my ($self) = @_;
	my  $IPv6 = getAddrValue($self,'ipv6'); 
	return $IPv6;
}

sub getAddrValue { 
	
	my ($self,$type) = @_;
	my  $returnValue = undef; 
	if ( ref($self->{Host}{address}) eq "ARRAY") {
		foreach (@{$self->{Host}{address}}) { if ( $_->{addrtype} eq $type ) { $returnValue = $_->{addr}; } } 
	} elsif (ref($self->{Host}{address}) eq "HASH") {
		if ( $self->{Host}{address}{addrtype} eq $type ) { $returnValue = $self->{Host}{address}{addr}} 
	} 
	return $returnValue;
}

#passed
sub tcp_port_count { 
	my ($self) = @_;
	my @ports = getPortdata($self,"tcp"); 
	return ($#ports + 1);	
}

#passed
sub udp_port_count { 
	my ($self) = @_;
	my @ports = getPortdata($self,"udp"); 
	return ($#ports + 1);		
}

#passed
sub tcp_ports { 
	my ($self,$state) = @_;
	my @ports = getPortdata($self,"tcp",$state); 
	return @ports;	
}

#passed
sub udp_ports {
	my ($self,$state) = @_;
	my @ports = getPortdata($self,"udp",$state); 
	return @ports;	
}

#passed
sub tcp_open_ports {
	my ($self,$state) = @_;
	my @ports = getPortdata($self,"tcp","open"); 
	return @ports;	 
}

#passed
sub udp_open_ports { 
	my ($self,$state) = @_;
	my @ports = getPortdata($self,"udp","open"); 
	return @ports;	 
}

#passed
sub tcp_filtered_ports { 
	my ($self,$state) = @_;
	my @ports = getPortdata($self,"tcp","filtered"); 
	return @ports;	 
}

#passed
sub udp_filtered_ports { 
	my ($self,$state) = @_;
	my @ports = getPortdata($self,"udp","filtered"); 
	return @ports;	
}

#passed
sub tcp_closed_ports {
	my ($self,$state) = @_;
	my @ports = getPortdata($self,"tcp","closed"); 
	return @ports;	 
	
}

#passed
sub udp_closed_ports {
	my ($self,$state) = @_;
	my @ports = getPortdata($self,"udp","closed"); 
	return @ports;	
}

sub getPortdata { 

	my ($self,$type,$state) = @_;
	my @ports; 
	
	if ( ref($self->{Host}{ports}) eq "ARRAY" ) { 
		foreach ( @{$self->{Host}{ports}}) { 
			if ( $_->{protocol} eq $type) {
				if (defined($state)) {
					if ( $_->{state}{state} eq $state) { 
						push(@ports,$_->{portid});
					} 
				} else { 
					push(@ports,$_->{portid});
				}  
				
			}
		}
	} 
#	else { 
#		die "no open ports error condition\n" 
#	}
	
	return @ports;	

}

sub status {
	my ($self) = @_;
	my $returnValue = "down";
	if ( defined($self->{Host}{status}{state}) ) { $returnValue = $self->{Host}{status}{state};  } 
	return $returnValue;	
}

#sub state { 
#	my ($self) = @_;
#	my $returnValue = "unknown"; 
#	
#	return $returnValue;
#}

	 	 
sub addr { 
	my ($self) = @_;
	
	my $addrValue; 
	if ( ref($self->{Host}{address}) eq "HASH") { 
		$addrValue = $self->{Host}{address}{addr};
	} elsif ( ref($self->{Host}{address}) eq "ARRAY" ){
		foreach ( @{$self->{Host}{address}}) { 
			if ( $_->{addrtype} eq "ipv4") { 
				$addrValue = $_->{addr};
				last;  
			}
		} 
	} else {
		printf "ref: %s\n", ref($self->{Host}{address});  
		die "unknown type! \n"; 
	}
	
	return $addrValue;
	
}

#passed
sub addrtype {
	 
	my ($self,$address) = @_;
	my $addrValue; 
	if ( ref($self->{Host}{address}) eq "HASH") { 
		$addrValue = $self->{Host}{address}{addrtype};
	} elsif ( ref($self->{Host}{address}) eq "ARRAY" ){
		foreach ( @{$self->{Host}{address}}) {
			if ( $_->{addr} eq $address) { 
				$addrValue = $_->{addrtype};
			} 
		} 
	} else {
		printf "ref: %s\n", ref($self->{Host}{address});  
		die "unknown type! \n"; 
	}
	return $addrValue;	
}

sub distance {
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{distance}{value})) { $returnValue = $self->{Host}{distance}{value}; } 
	return $returnValue;		
}

#passed
sub ipidsequence_class {
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{ipidsequence}{class})) { $returnValue = $self->{Host}{ipidsequence}{class}; } 
	return $returnValue;	
}

#passed
sub ipidsequence_values { 
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{ipidsequence}{values})) { $returnValue = $self->{Host}{ipidsequence}{values}; } 
	return $returnValue;				
}

#passed
sub tcpsequence_values {
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{tcpsequence}{values})) { $returnValue = $self->{Host}{tcpsequence}{values}; } 
	return $returnValue;				
}

#passed	
sub tcpsequence_index { 
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{tcpsequence}{index})) { $returnValue = $self->{Host}{tcpsequence}{index}; } 
	return $returnValue;		
}

sub tcpsequence_difficulty { 	
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{tcpsequence}{difficulty})) { $returnValue = $self->{Host}{tcpsequence}{difficulty}; } 
	return $returnValue;		
}

#passed
sub tcptssequence_class {
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{tcptssequence}{class})) { $returnValue = $self->{Host}{tcptssequence}{class}; } 
	return $returnValue;		
}

#passed
sub tcptssequence_values {
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{tcptssequence}{values})) { $returnValue = $self->{Host}{tcptssequence}{values}; } 
	return $returnValue;		
}

sub starttime { 
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{starttime})) { $returnValue = $self->{Host}{starttime}; } 
	return $returnValue;	
}

sub endtime { 
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{endtime})) { $returnValue = $self->{Host}{endtime}; } 
	return $returnValue;	
}
		
sub latency { 
	my ($self) = @_;
	my $returnValue = undef;
	if ( defined($self->{Host}{times}{srtt})) { $returnValue = $self->{Host}{times}{srtt}; } 
	return $returnValue;	
}
		
1;
