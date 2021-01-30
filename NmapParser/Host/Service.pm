# -------------------------------
package XML::NmapParser::Host::Service; 
use parent "XML::NmapParser::Host";

my @ISA = qw(XML::NmapParser::Host::Service Exporter);

use vars qw($AUTOLOAD);
# -------------------------------
our $VERSION = "0.3.0 c";

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
	my ($self) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{stem}{service}{name}) ) { $returnValue = $self->{stem}{service}{name}; }
	return $returnValue;
}

sub owner { 
	my ($self) = @_;
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
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{portid}) ) { $returnValue = $self->{stem}{state}{state}; }
	return $returnValue;	
}
sub reason { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{portid}) ) { $returnValue = $self->{stem}{state}{reason}; }
	return $returnValue;	
}
sub reason_ttl { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{portid}) ) { $returnValue = $self->{stem}{state}{reason_ttl}; }
	return $returnValue;		
}
# new calls END 

sub confidence { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{conf}) ) { $returnValue = $self->{stem}{service}{conf}; }
	return $returnValue;	
}

sub extrainfo { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{extrainfo}) ) { $returnValue = $self->{stem}{service}{extrainfo}; }
	return $returnValue;	
}

sub method { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{method}) ) { $returnValue = $self->{stem}{service}{method}; }
	return $returnValue;	
}

sub product { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{product}) ) { $returnValue = $self->{stem}{service}{product};}
	return $returnValue;
}

sub version { 	
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{version}) ) { $returnValue = $self->{stem}{service}{version}; }
	return $returnValue;
}

sub ostype { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{ostype}) ) { $returnValue = $self->{stem}{service}{ostype}; }
	return $returnValue;	
}

sub devicetype { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{devicetype}) ) { $returnValue = $self->{stem}{service}{devicetype}; }
	return $returnValue;	
}

sub proto { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{protocol}) ) { $returnValue = $self->{stem}{protocol}; }
	return $returnValue;
}

sub tunnel { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{service}{tunnel}) ) { $returnValue = $self->{stem}{service}{tunnel}; }
	return $returnValue;	
}

sub port { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{portid}) ) { $returnValue = $self->{stem}{portid}; }
	return $returnValue;	
}

sub protocol { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{protocol}) ) { $returnValue = $self->{stem}{protocol}; }
	return $returnValue;
}

sub protocol { 
	my ($self) = @_;
	my $returnValue = -1; 
	if ( defined($self->{stem}{protocol}) ) { $returnValue = $self->{stem}{protocol}; }
	return $returnValue;
}

 
