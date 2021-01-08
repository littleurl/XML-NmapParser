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



=head1 NAME

NmapParser - parse nmap scan data with perl

=head1 SYNOPSIS

  use Nmap::Parser::Host::TraceHop;
  my $host = Nmap::Parser::Host::TraceHop->new();

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