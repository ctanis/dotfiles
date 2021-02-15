#!/usr/bin/perl -w
use strict;

my ($tag, $path) = @ARGV;
my $export_mode='bash';
my @order;
#print "getting $tag from $path\n";
if ($tag eq '-') {
  open DAT, "$path" or die "cannot open $path";
  ## option listing mode
  while (<DAT>) {
    my $new_tag;

    if (($new_tag) = m/^\s*\[([a-z0-9_]+)\]/i) {
      print "$new_tag " unless $new_tag eq '*';
    }

  }
  print "\n";
  exit;
}

my %newenv;
## turn off all variables in this file
open DAT, "$path" or die "cannot open $path";
while (<DAT>) {
  my ($expvar) = m/^\s*([a-z0-9_]+)\s*=/i;
  next unless $expvar;
  $newenv{$expvar}=undef;
}




## select block
open DAT, "$path" or die "cannot open $path";
my $in_block=1;
my %vars;

while (<DAT>) {
  chomp;
  my ($new_tag, $varname, $varvalue);
  
  next if m/^\s*#/;
  next if m/^\s*$/;

  # selection
  if (($new_tag) = m/^\s*\[([a-z0-9_*]+)\]/i) {

    if ((lc $new_tag eq lc $tag) or ($new_tag eq '*')) {
      $in_block = 1;
    } else {
      $in_block = 0;
    }
    next;
  }

  if ($in_block) {
    s/%([a-z_]+)%(?!=)/$vars{$1}/gi;

    if (($varname,$varvalue)= m/^\s*%([a-z0-9_]+)%=(.*)\s*$/i) {
      $vars{$varname}=$varvalue;
    }
    else {
      my ($k,$v) = m/^\s*([a-z0-9_]+)\s*=\s*(.*)$/i;
      $newenv{$k}=$v;
      push @order, $k;
    }
  }
}

if ($export_mode eq 'bash') {

  for my $k (@order) {
    print "export $k=$newenv{$k};\n";
    delete $newenv{$k};
  }

  for my $k (keys %newenv) {
    print "unset $k;\n";
  }

} else {
  die "unsupported mode: $export_mode\n";
}
      
