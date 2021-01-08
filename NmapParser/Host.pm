# -------------------------------
package XML::NmapParser::Host;

our $VERSION = "0.2.2 b";

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
__END__

=pod

=head1 NAME

NmapParser - parse nmap scan data with perl

=head1 SYNOPSIS

  use XML::NmapParser::Host;
  my $host = XML::NmapParser::Host->new();

=head1 DESCRIPTION


=head1 OVERVIEW

=head1 METHODS

=head2 Nmap::Parser::Host

This object represents the information collected from a scanned host.


=over 4

=item B<status()>

Returns the state of the host. It is usually one of these
C<(up|down|unknown|skipped)>.

=item B<addr()>

Returns the main IP address of the host. This is usually the IPv4 address. If
there is no IPv4 address, the IPv6 is returned (hopefully there is one).

=item B<addrtype()>

Returns the address type of the address given by addr() .

=item B<all_hostnames()>

Returns a list of all hostnames found for the given host.

=item B<extraports_count()>

Returns the number of extraports found.

=item B<extraports_state()>

Returns the state of all the extraports found.

=item B<hostname()>

=item B<hostname($index)>

As a basic call, hostname() returns the first hostname obtained for the given
host. If there exists more than one hostname, you can provide a number, which
is used as the location in the array. The index starts at 0;

 #in the case that there are only 2 hostnames
 hostname() eq hostname(0);
 hostname(1); #second hostname found
 hostname(400) eq hostname(1) #nothing at 400; return the name at the last index
 

=item B<ipv4_addr()>

Explicitly return the IPv4 address.

=item B<ipv6_addr()>

Explicitly return the IPv6 address.

=item B<mac_addr()>

Explicitly return the MAC address.

=item B<mac_vendor()>

Return the vendor information of the MAC.

=item B<distance()>

Return the distance (in hops) of the target machine from the machine that performed the scan.

=item B<trace_error()>

Returns a true value (usually a meaningful error message) if the traceroute was
performed but could not reach the destination. In this case C<all_trace_hops()>
contains only the part of the path that could be determined.

=item B<all_trace_hops()>

Returns an array of Nmap::Parser::Host::TraceHop objects representing the path
to the target host. This array may be empty if Nmap did not perform the
traceroute for some reason (same network, for example).

Some hops may be missing if Nmap could not figure out information about them.
In this case there is a gap between the C<ttl()> values of consecutive returned
hops. See also C<trace_error()>.

=item B<trace_proto()>

Returns the name of the protocol used to perform the traceroute.

=item B<trace_port()>

Returns the port used to perform the traceroute.

=item B<os_sig()>

Returns an Nmap::Parser::Host::OS object that can be used to obtain all the
Operating System signature (fingerprint) information. See Nmap::Parser::Host::OS
for more details.

 $os = $host->os_sig;
 $os->name;
 $os->osfamily;

=item B<tcpsequence_class()>

=item B<tcpsequence_index()>

=item B<tcpsequence_values()>

Returns the class, index and values information respectively of the tcp sequence.

=item B<ipidsequence_class()>

=item B<ipidsequence_values()>

Returns the class and values information respectively of the ipid sequence.

=item B<tcptssequence_class()>

=item B<tcptssequence_values()>

Returns the class and values information respectively of the tcpts sequence.

=item B<uptime_lastboot()>

Returns the human readable format of the timestamp of when the host had last
rebooted.

=item B<uptime_seconds()>

Returns the number of seconds that have passed since the host's last boot from
when the scan was performed.

=item B<hostscripts()>

=item B<hostscripts($name)>

A basic call to hostscripts() returns a list of the names of the host scripts
run. If C<$name> is given, it returns the text output of the
a reference to a hash with "output" and "content" keys for the
script with that name, or undef if that script was not run.
The value of the "output" key is the text output of the script. The value of the
"content" key is a data structure based on the XML output of the NSE script.

=item B<tcp_ports()>

=item B<udp_ports()>

Returns the sorted list of TCP|UDP ports respectively that were scanned on this host. Optionally
a string argument can be given to these functions to filter the list.

 $host->tcp_ports('open') #returns all only 'open' ports (even 'open|filtered')
 $host->udp_ports('open|filtered'); #matches exactly ports with 'open|filtered'
 
I<Note that if a port state is set to 'open|filtered' (or any combination), it will
be counted as an 'open' port as well as a 'filtered' one.>

=item B<tcp_port_count()>

=item B<udp_port_count()>

Returns the total of TCP|UDP ports scanned respectively.

=item B<tcp_del_ports($portid, [$portid, ...])>

=item B<udp_del_ports($portid, [ $portid, ...])>

Deletes the current $portid from the list of ports for given protocol.

=item B<tcp_port_state($portid)>

=item B<udp_port_state($portid)>

Returns the state of the given port, provided by the port number in $portid.

=item B<tcp_open_ports()>

=item B<udp_open_ports()>

Returns the list of open TCP|UDP ports respectively. Note that if a port state is
for example, 'open|filtered', it will appear on this list as well. 

=item B<tcp_filtered_ports()>

=item B<udp_filtered_ports()>

Returns the list of filtered TCP|UDP ports respectively. Note that if a port state is
for example, 'open|filtered', it will appear on this list as well. 

=item B<tcp_closed_ports()>

=item B<udp_closed_ports()>

Returns the list of closed TCP|UDP ports respectively. Note that if a port state is
for example, 'closed|filtered', it will appear on this list as well. 

=item B<tcp_service($portid)>

=item B<udp_service($portid)>

Returns the Nmap::Parser::Host::Service object of a given service running on port,
provided by $portid. See Nmap::Parser::Host::Service for more info. 

 $svc = $host->tcp_service(80);
 $svc->name;
 $svc->proto;
 

=back

=head3 Nmap::Parser::Host::Service

This object represents the service running on a given port in a given host. This
object is obtained by using the tcp_service($portid) or udp_service($portid) method from the
Nmap::Parser::Host object. If a portid is given that does not exist on the given
host, these functions will still return an object (so your script doesn't die).
Its good to use tcp_ports() or udp_ports() to see what ports were collected.

=over 4


=item B<confidence()>

Returns the confidence level in service detection.

=item B<extrainfo()>

Returns any additional information nmap knows about the service.

=item B<method()>

Returns the detection method.

=item B<name()>

Returns the service name.

=item B<owner()>

Returns the process owner of the given service. (If available)

=item B<port()>

Returns the port number where the service is running on.

=item B<product()>

Returns the product information of the service.

=item B<proto()>

Returns the protocol type of the service.

=item B<rpcnum()>

Returns the RPC number.

=item B<tunnel()>

Returns the tunnel value. (If available)

=item B<fingerprint()>

Returns the service fingerprint. (If available)
 
=item B<version()>

Returns the version of the given product of the running service.

=item B<scripts()>

=item B<scripts($name)>

A basic call to scripts() returns a list of the names of the NSE scripts
run for this port. If C<$name> is given, it returns
a reference to a hash with "output" and "content" keys for the
script with that name, or undef if that script was not run.
The value of the "output" key is the text output of the script. The value of the
"content" key is a data structure based on the XML output of the NSE script.

=back

=head3 Nmap::Parser::Host::OS

This object represents the Operating System signature (fingerprint) information
of the given host. This object is obtained from an Nmap::Parser::Host object
using the C<os_sig()> method. One important thing to note is that the order of OS
names and classes are sorted by B<DECREASING ACCURACY>. This is more important than
alphabetical ordering. Therefore, a basic call
to any of these functions will return the record with the highest accuracy.
(Which is probably the one you want anyways).

=over 4

=item B<all_names()>

Returns the list of all the guessed OS names for the given host.

=item B<class_accuracy()>

=item B<class_accuracy($index)>

A basic call to class_accuracy() returns the osclass accuracy of the first record.
If C<$index> is given, it returns the osclass accuracy for the given record. The
index starts at 0.

=item B<class_count()>

Returns the total number of OS class records obtained from the nmap scan.

=item B<name()>

=item B<name($index)>

=item B<names()>

=item B<names($index)>

A basic call to name() returns the OS name of the first record which is the name
with the highest accuracy. If C<$index> is given, it returns the name for the given record. The
index starts at 0.

=item B<name_accuracy()>

=item B<name_accuracy($index)>

A basic call to name_accuracy() returns the OS name accuracy of the first record. If C<$index> is given, it returns the name for the given record. The
index starts at 0.

=item B<name_count()>

Returns the total number of OS names (records) for the given host.

=item B<osfamily()>

=item B<osfamily($index)>

A basic call to osfamily() returns the OS family information of the first record.
If C<$index> is given, it returns the OS family information for the given record. The
index starts at 0.

=item B<osgen()>

=item B<osgen($index)>

A basic call to osgen() returns the OS generation information of the first record.
If C<$index> is given, it returns the OS generation information for the given record. The
index starts at 0.

=item B<portused_closed()>

Returns the closed port number used to help identify the OS signatures. This might not
be available for all hosts.

=item B<portused_open()>

Returns the open port number used to help identify the OS signatures. This might
not be available for all hosts.

=item B<os_fingerprint()>

Returns the OS fingerprint used to help identify the OS signatures. This might not be available for all hosts.

=item B<type()>

=item B<type($index)>

A basic call to type() returns the OS type information of the first record.
If C<$index> is given, it returns the OS type information for the given record. The
index starts at 0.

=item B<vendor()>

=item B<vendor($index)>

A basic call to vendor() returns the OS vendor information of the first record.
If C<$index> is given, it returns the OS vendor information for the given record. The
index starts at 0.

=back

=head3 Nmap::Parser::Host::TraceHop

This object represents a router on the IP path towards the destination or the
destination itself. This is similar to what the C<traceroute> command outputs.

Nmap::Parser::Host::TraceHop objects are obtained through the
C<all_trace_hops()> and C<trace_hop()> Nmap::Parser::Host methods.

=over 4

=item B<ttl()>

The Time To Live is the network distance of this hop.

=item B<rtt()>

The Round Trip Time is roughly equivalent to the "ping" time towards this hop.
It is not always available (in which case it will be undef).

=item B<ipaddr()>

The known IP address of this hop.

=item B<host()>

The host name of this hop, if known.

=back

=head1 EXAMPLES

 use Nmap::Parser;

 my $np = new Nmap::Parser;
 my @hosts = @ARGV; #get hosts from cmd line


=head1 SUPPORT

=head2 Discussion Forum

If you have questions about how to use the module please contact the author below.

=head2 Bug Reports, Enhancements, Merge Requests

Please submit any bugs or feature requests to:
L<https://github.com/littleurl/XML-NmapParser/issues>


=head1 SEE ALSO

nmap, XML::LibXML 

The nmap security scanner homepage can be found at: L<http://www.insecure.org/nmap/>.

=head1 AUTHORS

Paul M Johnson <pjohnson21211@gmail.com>
but credit to the original author of Nmap-Parser is Anthony Persaud L <http://modernistik.com>


=head1 COPYRIGHT

1; 
