#!/usr/bin/perl -w
use strict;
use List::Util qw(shuffle);
use vars qw($per_student);
use Data::Dumper;

($per_student) = @ARGV;
my @names = <STDIN>;
chomp @names;


my @assigned=();
for (1...$per_student) {
  unshift @assigned, @names;   
}

@assigned = shuffle @assigned;
@assigned = shuffle @assigned;
@assigned = shuffle @assigned;

@names = shuffle @names;


my %mapped;
local $"=","; 
my %cohort;
my $failed=0;

while(@names) {
  my $n = shift @names;
  my $myref;
  $cohort{$n} = $myref = {};

  my $fail=0;
  for (1...$per_student) {
  HERE:
    last unless @assigned;
    my $c = pop @assigned;

#    print "considering $c for $n\n";

    if ($c eq $n or defined $myref->{$c}) {
      unshift @assigned, $c;

      if ($fail++ >= $per_student) {
        $failed=1;
        last;
      }

      goto HERE;
    } else {
      $myref->{$c}=1;
      $mapped{$c}++;
    }
  }

  # if ($fail >= $per_student) {
  #   # swap
  #   for (my $i =0; $i< @names; $i++) {
  #     if ()
  #   }
  # }


  my @m=keys %$myref;
  print "FAIL @assigned\n" if $failed;
  # print "$n(",scalar @m,") -> @m\n";
}

for my $n (sort {$a cmp $b} keys %cohort) {
  local $"=", ";
  my @pals = sort {$a cmp $b} keys %{$cohort{$n}};
  print "$n -> @pals\n";
}


#print Dumper(\%cohort);

if ($failed) {
  print "FAILED to map everybody\n";
#  print Dumper(\%mapped);
}
