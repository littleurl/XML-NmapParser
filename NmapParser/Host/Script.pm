# -------------------------------
package XML::NmapParser::Host::Script; 
use base "XML::NmapParser::Host";

our $VERSION = "0.1.2";

use strict;
use warnings;
use Carp; 
use Exporter;

# use parent 'XML::NmapParser::Host'; 
# require XML::NmapParser;

my @ISA = qw(XML::NmapParser::Host::Script Exporter);

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


=head1 NAME

NmapParser - parse nmap scan data with perl

=head1 SYNOPSIS

  use Nmap::Parser::Host::Script;
  my $host = Nmap::Parser::Host::Script->new();

=head1 DESCRIPTION

=head1 OVERVIEW

=head1 METHODS

=head2 Nmap::Parser::Host::Service

This object represents the information collected from a scanned host.


=over 4


=head3 

This object represents a router on the IP path towards the destination or the
destination itself. This is similar to what the C<traceroute> command outputs.

Nmap::Parser::Host::TraceHop objects are obtained through the
C<all_trace_hops()> and C<trace_hop()> Nmap::Parser::Host methods.

=over 4

=item B<all()>

The Time To Live is the network distance of this hop.

=item B<name()>

The Round Trip Time is roughly equivalent to the "ping" time towards this hop.
It is not always available (in which case it will be undef).

=item B<elements()>

The known IP address of this hop.

=item B<output()>

The host name of this hop, if known.

=back

=head1 EXAMPLES

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