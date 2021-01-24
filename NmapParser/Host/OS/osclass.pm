# -------------------------------
package XML::NmapParser::Host::OS::osclass;
use parent 'XML::NmapParser::Host::OS'; 

my @ISA = qw(XML::NmapParser::Host::OS::osclass Exporter);

use vars qw($AUTOLOAD);
# -------------------------------
our $VERSION = "0.2.0 a";

sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;

    $self->SUPER::initialize(shift, shift);
    $self->{OSclass} = $self->{stem};
    return $self;
}

sub initialize {
    my $self = shift;
    $self->SUPER::initialize(shift, shift);
    $self->{OSclass} = shift;
}


sub vendor { 
	my ($self) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{OSclass}{vendor}) ) { $returnValue = $self->{OSclass}{vendor};  }
	return $returnValue;
} 


sub generation { 
	my ($self) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{OSclass}{osgen}) ) { $returnValue = $self->{OSclass}{osgen};  }
	return $returnValue;
} 


sub family { 
	my ($self) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{OSclass}{osfamily}) ) { $returnValue = $self->{OSclass}{osfamily};  }
	return $returnValue;
} 


sub type { 
	my ($self) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{OSclass}{type}) ) { $returnValue = $self->{OSclass}{type};  }
	return $returnValue;
} 


 
sub accuracy { 
	my ($self) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{OSclass}{accuracy}) ) { $returnValue = $self->{OSclass}{accuracy};  }
	return $returnValue;
} 

sub cpe { 
	my ($self) = @_;
	my @returnValue; 
	if ( defined($self->{OSclass}{cpe}) ) {
		foreach ( @{$self->{OSclass}{cpe}}) { 
			push(@returnValue,$_);
		} 
	}
	return @returnValue;
}

1;
