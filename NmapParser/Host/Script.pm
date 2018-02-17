# -------------------------------
package NmapParser::Host::Script; 
use base "NmapParser::Host";

our $VERSION = "0.1.2";

use strict;
use warnings;
use Carp; 
use Exporter;

use parent 'NmapParser::Host'; 
require NmapParser;

my @ISA = qw(NmapParser::Host::Script Exporter);

use vars qw($AUTOLOAD);
# -------------------------------


sub new {
    my $pkg = shift;
    my $self = bless {}, $pkg;

    $self->SUPER::initialize(shift, shift);
    $self->{Script} = $self->{stem};
    return $self;
}

#sub new {
#    my $pkg = shift;
#    my $self = bless {}, $pkg;
#    $self->initialize(@_);
#    return $self;
#}

sub initialize {
    my $self = shift;
    $self->SUPER::initialize(shift, shift);
    $self->{HOST} = shift;
}

sub all {
	
	my ($self) = @_;
	my @names;
	foreach ( @{$self->{stem}{osmatch}} ) { push(@names,$_->{name});}	
	return @names;		 

}

sub name { 

	my ($self,$port) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{stem}{id}) ) { $returnValue = $self->{stem}{id}; }
	return $returnValue;
} 

sub elements { 

	my ($self,$port) = @_;
	my %returnValue; 
	if ( defined($self->{stem}{elem}) ) {
		foreach ( keys %{$self->{stem}{elem}} ) { $returnValue{$_} = $self->{stem}{elem}{$_};}
	}
	return \%returnValue;
}

sub output { 

	my ($self,$port) = @_;
	my $returnValue = "unknown"; 
	if ( defined($self->{stem}{output}) ) { $returnValue = $self->{stem}{output}; }
	return $returnValue;	
	
}