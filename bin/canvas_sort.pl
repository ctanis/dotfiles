#!/usr/local/bin/perl -w

## sort files downloaded as a canvas assignment, into directories per user
## name.  Run corresponding `postprocess` command as needed


use strict;

my %postprocess =
  (
   zip => "unzip",
   rar => "unrar"
  );



sub do_postprocess($$) {
  my ($dir, $file) = @_;

  chdir $dir;
  
 PROCESS:
  for my $k (keys %postprocess) {

    if ($file =~ /.*\.$k$/) {
      ## found a match

      print "$file matches $k\n";

      system($postprocess{$k} . " $file" );
      last PROCESS;
    }
  }

  rmdir "__MACOSX";
  chdir "..";
}


## main

for my $f (glob "*") {

  #my ($user, $fname) = $f =~ m/([^_]+)_[0-9]+_[0-9]+_(.*)/;
  my ($user, $islate, $fname) = $f =~ m/^([^_]+)(_LATE)?_[0-9]+_[0-9]+_(.*)/;

  $fname =~ s/[\s\(\)]/_/g;
  print "$f --> `$user`($fname)\n";
  print "**ISLATE\n" if $islate;


  mkdir $user;
  rename $f, "$user/$fname";

  
  do_postprocess($user, $fname);
}


