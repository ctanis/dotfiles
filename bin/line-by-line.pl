#!/usr/bin/perl -w

# like a very verbose diff ...

my ($f1, $f2) = @ARGV;

open EXP, $f1 or die;
open ACT, $f2 or die;


$line=0;
for $eline (<EXP>) {

  $aline = <ACT>;

  chomp $eline;
  chomp $aline;

  if ($aline ne $eline)
    {
      print "line $line\n";
      print "expected: $eline\n  actual: $aline\n";
    }
  else
    {
      print "line $line\n";
      print "OK: $eline\n";
    }


  $line++;
}
