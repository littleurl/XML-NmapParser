# -------------------------------
package NmapParser::Host::OS::osmatch; 
use base NmapParser::Host::OS;

our $VERSION = "0.1.0a";

use strict;
use warnings;
use Carp; 
use Exporter;

use parent 'NmapParser::Host'; 
require NmapParser;

my @ISA = qw(NmapParser::Host::OS::osmatch Exporter);

use vars qw($AUTOLOAD);
# -------------------------------osmatch

sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;

    $self->SUPER::initialize(shift, shift);
    $self->{OSmatch} = $self->{stem};
    return $self;
}

sub initialize {
    my $self = shift;
    $self->SUPER::initialize(shift, shift);
    $self->{OSmatch} = shift;
}


sub name { 
	my ($self) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{OSmatch}{name}) ) { $returnValue = $self->{OSmatch}{name};  }
	return $returnValue;
} 

sub accuracy { 
	my ($self) = @_;
	my $returnValue = "unknown";
	if ( defined($self->{OSmatch}{accuracy}) ) { $returnValue = $self->{OSmatch}{accuracy}; } 
	return $returnValue;
} 
 

sub line { 
	my ($self) = @_;
	my $returnValue = "unknown";
	if ( defined($self->{OSmatch}{line}) ) { $returnValue = $self->{OSmatch}{line}; } 
	return $returnValue;
} 

sub osclass { 
	use NmapParser::Host::OS::osclass; 
	
	my ($self) = @_;
	my @ALL;
	foreach ( @{$self->{OSmatch}{osclass}} ) {
		# return an array of OS objects......
		my $osclass = NmapParser::Host::OS::osclass->new($_);
 
		push(@ALL,$osclass);
	}	
	return @ALL;	
}

1;
