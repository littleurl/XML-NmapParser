# -------------------------------
package NmapParser::Host::OS; 
use base "NmapParser::Host";

our $VERSION = "0.2.3";

use strict;
use warnings;
use Carp; 
use Exporter;

require NmapParser;

my @ISA = qw(NmapParser::Host::OS Exporter);

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
    $self->{OS} = shift;
}

sub all {
	use NmapParser::Host::OS::osmatch; 
	
	my ($self) = @_;
	my @ALL;
	foreach ( @{$self->{stem}{osmatch}} ) {
		# return an array of OS objects......
		my $osmatch = NmapParser::Host::OS::osmatch->new($_);
		push(@ALL,$osmatch);
	}	
	return @ALL;		 

}

sub fingerprint { 
	my ($self) = @_;
	my $returnValue = "unknown";
	if ( defined($self->{stem}{osfingerprint}) ) { $returnValue = $self->{stem}{osfingerprint}; } 
	return $returnValue;
}

sub class { 
	use NmapParser::Host::OS::osclass; 
	
	my ($self) = @_;
	my @ALL;
	if ( @{$self->{stem}{osmatch}{osclass}} ) { 
		foreach ( @{$self->{stem}{osmatch}{osclass}} ) {
			# return an array of OS objects......
			my $osmatch = NmapParser::Host::OS::osmatch->new($_);
			push(@ALL,$osmatch);
		}			
	}
	return @ALL;		 
	
	
	
}

1; 
