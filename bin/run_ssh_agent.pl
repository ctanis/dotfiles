#!/usr/bin/perl -w
use strict;
  
my $cache_file="$ENV{HOME}/.ssh-agent";

my $running_pid=-1;
my $cached_pid=-1;
my @cache;
my $resave_cache=0;

## check for running agnet
{
  my @pid = `ps aux |gawk '/ssh-agent/ { print \$1 }'`;
  chomp @pid;
  
  die "too many ssh-agent processes: @pid\n" if scalar @pid > 1;
  $running_pid=$pid[0] if scalar @pid == 1;
}

if (-e $cache_file) {

  open CACHE, $cache_file or die "cannot read $cache_file: $!";
  @cache=<CACHE>;
  ($cached_pid) = $cache[2]=~m/#echo Agent pid (\d+)/;
  close CACHE;
}


if ($running_pid == -1) {
  @cache=`/usr/bin/ssh-agent -s`;
  $cache[2]="#".$cache[2];
  $resave_cache=1;
} else {
  die "ssh-agent cache out of sync with reality\n" if $cached_pid ne $running_pid;
}

print "@cache\n";

if ($resave_cache) {
  open CACHE, ">$cache_file" or die "cannot open $cache_file: $!";

  print CACHE @cache;
  close CACHE;  
}
