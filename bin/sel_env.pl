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

# match multiple tags 
my @tags=map lc, split /\./, $tag;

my %valid_tag;
map { $valid_tag{$_}=undef; } @tags;

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

    no warnings;
    if (($new_tag eq '*' ) or lc $new_tag ~~ @tags) {

      $valid_tag{$new_tag}=1;

      $in_block = 1;
    } else {
      $in_block = 0;
    }
    next;
  }

  if ($in_block) {
    no warnings;
    s/%([a-z_]+)%(?!=)/$vars{$1}/gi;
    s/\$\{(.*?)\}/$newenv{$1}/g;

    if (($varname,$varvalue)= m/^\s*%([a-z0-9_]+)%=(.*)\s*$/i) {
      $vars{$varname}=$varvalue;
    }
    else {
      my ($k,$v) = m/^\s*([a-z0-9_]+)\s*=\s*(.*)$/i;
      $newenv{$k}=$v;

      # remove $k from order
      @order = grep { $_ ne $k } @order;
      push @order, $k;
    }
  }
}

my @unknown= grep { !defined $valid_tag{$_} } keys %valid_tag;

if (@unknown)  {
  die "unkown tag: @unknown\n";
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
      
