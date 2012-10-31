#!/usr/bin/perl

use 5.010;
use warnings;
use strict;

use FindBin;
use Pod::Usage;
use Getopt::Long;
use Template;

my $template  = "$FindBin::Bin/slides.tt";
my $directory = "./slides/";
my $verbose;

GetOptions(
    'help|?'      => sub { pod2usage(1) },
    'man'         => sub { pod2usage( { -verbose => 2, -noperldoc => 1 } ) },
    'verbose'     => \$verbose,
    'directory=s' => \$directory,
    'template=s'  => \$template,
) or pod2usage(2);

# two blank lines separate slides
my @slides = split /\n{3,}/, join "", <>;

# honor line breaks
for (@slides) {
    s/\n/  \n/g;
}

# process
my $tt = Template->new({ ABSOLUTE => 1 });
$tt->process($template, {
    slides => \@slides,
}, "$directory/index.html") || die $tt->error();

# copy support files
`cp -r $FindBin::Bin/../{lib,js,plugin,css} $directory`;

__END__

=head1 NAME

  make-slides.pl - Markdown to reveal.js presentation processor  

=head1 SYNOPSIS

  make-slides.pl < [file]
  make-slides.pl [file]
  make-slides.pl [file] -d [outdir]
  make-slides.pl [file] -t [template]  

=head1 OPTIONS

=over 8

=item B<-directory>

Target directory to write presentation files to. The current directory will be used if none is specified.

=item B<-template>

Template file to use. If none is specified, slides.tt in the directory where this script is will be used.

=item B<-verbose>

Verbose output will be sent to STDOUT.

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> will read the given input file and create a reveal.js 
presentation in the current or specified directly. 

=head1 AUTHOR

Erik J. Sturcke

=cut
