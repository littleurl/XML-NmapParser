# -------------------------------
package XML::NmapParser::Host::TraceHop; 
use base "XML::NmapParser::Host";

our $VERSION = "0.1.2";

use strict;
use warnings;
use Carp; 
use Exporter;

use parent 'XML::NmapParser::Host'; 
require XML::NmapParser;

my @ISA = qw(XML::NmapParser::Host::TraceHop Exporter);

use vars qw($AUTOLOAD);
# -------------------------------


sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;

    $self->SUPER::initialize(shift, shift);
    $self->{TraceHop} = $self->{stem};
    return $self;
}

sub ttl{ 
        my ($self) = @_;
        my $returnValue = "unknown"; 
        if ( defined($self->{TraceHop}{ttl}) ) { $returnValue = $self->{TraceHop}{ttl};  }
        return $returnValue;
}

sub rtt{ 
        my ($self) = @_;
        my $returnValue = "unknown"; 
        if ( defined($self->{TraceHop}{rtt}) ) { $returnValue = $self->{TraceHop}{rtt};  }
        return $returnValue;
}

sub ipaddr{ 
        my ($self) = @_;
        my $returnValue = "unknown"; 
        if ( defined($self->{TraceHop}{ipaddr}) ) { $returnValue = $self->{TraceHop}{ipaddr};  }
        return $returnValue;
}

sub host{ 
        my ($self) = @_;
        my $returnValue = "unknown"; 
	if ( defined($self->{TraceHop}{host}) ) { $returnValue = $self->{TraceHop}{host};  }
        return $returnValue;
}



1; 
