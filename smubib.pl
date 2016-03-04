###############################################################################################
# sjohnson from Freenode originally gave a proof of concept for this project written in Perl. #
# This work is released under the MIT License: https://opensource.org/licenses/MIT       	  #
###############################################################################################

#!/usr/bin/perl

use strict;
use warnings;

use 5.010;

use File::Basename;
use Text::CSV;

# ---

my $file_csv;

foreach (@ARGV) {
  if (m/^-h|--help$/) { print usage(); exit(0); }
  elsif (! defined($file_csv) && -r $_) { $file_csv = $_; }
  else {
    say STDERR "unrecognized argument or unreadable file.  exiting.";
    exit(1);
  }
}

if (! defined($file_csv)) {
  print usage();
  exit(1);
}

# ---

my $csv = Text::CSV->new() or die "Cannot use CSV: " . Text::CSV->error_diag();
open(my $fh_csv, '<', $file_csv) or die "$file_csv $!";

my @headers;
my @row_refs;

# collect data
while (my $row = $csv->getline($fh_csv)) {
  if ($. == 1) {
    # populate headers, first row only
    my $count_header_field = 0;
    foreach my $piece (@$row) {
      $headers[$count_header_field++] = $piece;
    }

    # done collecting headers
    next;
  }

  push(@row_refs, $row);
}

$csv->eof or $csv->error_diag();
close($fh_csv);

# output the data to bibtex
foreach my $row_ref (@row_refs) {
  my $c = -1;

  foreach my $field (@$row_ref) {
    trim($field);

    ++$c;
    if ($c == 0) {
      print '@' . $field . '{';
    } elsif ($c == 1) {
      print $field . ",\n"
    } elsif (length($field)) {
      print "$headers[$c] = {$field},\n";
    }
  }
  print "}\n\n";
}

# ---

sub trim { $_[0] =~ s{^\s+|\s+$}{}g; }

sub usage {
  my $buffer;

  $buffer .= "Purpose: To translate basic Google-formatted spreadsheets saved as .csv to BibTeX ...\n\n";
  $buffer .= "Usage: " . basename($0) . " (-h|--help) [file.csv] > [file.bib]\n";

  return $buffer;
}

