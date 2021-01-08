# -------------------------------
package XML::NmapParser::Host::Service; 
use base "XML::NmapParser::Host";

our $VERSION = "0.1.2";

use strict;
use warnings;
use Carp; 
use Exporter;

# use parent 'XML::NmapParser::Host'; 
# require XML::NmapParser;

my @ISA = qw(XML::NmapParser::Host::Service Exporter);

use vars qw($AUTOLOAD);
# -------------------------------

sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;
    $self->initialize(@_);
    return $self;
}


sub initialize {
    my $self = shift;
    $self->SUPER::initialize(shift, shift);
    $self->{HOST} = shift;
}

sub name { 
	my ($self,$port) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{stem}{service}{name}) ) { $returnValue = $self->{stem}{service}{name}; }
	return $returnValue;
}

sub owner { 
	my ($self,$port) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{stem}{service}{owner}) ) { $returnValue = $self->{stem}{service}{owner}; }
	return $returnValue;
}


#sub rpcnum { }
#sub fingerprint { }
#sub owner { }


sub scripts { 
	use XML::NmapParser::Host::Script; 
	
	my ($self,$name) = @_;
	my @scripts;

	if ( defined($self->{stem}{scripts})) { 
		foreach ( @{$self->{stem}{scripts}} ) {
			# return an array of OS objects......
			my $script = XML::NmapParser::Host::Script->new($_);
			push(@scripts,$script);
		}
	}	
	return @scripts;		 
}

# new calls START  
sub cpe { 
	my ($self,$index) = @_;
	my @CPE;  
	if ( defined($self->{stem}{service}{cpe}) ) {
		if (defined($index)) { 
			push(@CPE,${$self->{stem}{service}{cpe}}[$index] );
		}
		else { 
			foreach ( @{$self->{stem}{service}{cpe}}) {
				push(@CPE,$_); 
			} 			
		} 
	}
	return @CPE;	
}

sub state { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{portid}) ) { $returnValue = $self->{stem}{state}{state}; }
	return $returnValue;	
}
sub reason { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{portid}) ) { $returnValue = $self->{stem}{state}{reason}; }
	return $returnValue;	
}
sub reason_ttl { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{portid}) ) { $returnValue = $self->{stem}{state}{reason_ttl}; }
	return $returnValue;		
}
# new calls END 

sub confidence { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{conf}) ) { $returnValue = $self->{stem}{service}{conf}; }
	return $returnValue;	
}

sub extrainfo { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{extrainfo}) ) { $returnValue = $self->{stem}{service}{extrainfo}; }
	return $returnValue;	
}

sub method { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{method}) ) { $returnValue = $self->{stem}{service}{method}; }
	return $returnValue;	
}

sub product { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{product}) ) { $returnValue = $self->{stem}{service}{product};}
	return $returnValue;
}

sub version { 	
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{version}) ) { $returnValue = $self->{stem}{service}{version}; }
	return $returnValue;
}

sub ostype { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{ostype}) ) { $returnValue = $self->{stem}{service}{ostype}; }
	return $returnValue;	
}

sub devicetype { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{devicetype}) ) { $returnValue = $self->{stem}{service}{devicetype}; }
	return $returnValue;	
}

sub proto { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{protocol}) ) { $returnValue = $self->{stem}{protocol}; }
	return $returnValue;
}


sub tunnel { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{tunnel}) ) { $returnValue = $self->{stem}{service}{tunnel}; }
	return $returnValue;	
}

sub port { 
	my ($self,$port) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{portid}) ) { $returnValue = $self->{stem}{portid}; }
	return $returnValue;	
}

__END


=head1 NAME

NmapParser - parse nmap scan data with perl

=head1 SYNOPSIS

  use Nmap::Parser::Host::Service;
  my $host = Nmap::Parser::Host::Service->new();

=head1 DESCRIPTION

=head1 OVERVIEW

=head1 METHODS

=head2 Nmap::Parser::Host::Service

This object represents the information collected from a scanned host.


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