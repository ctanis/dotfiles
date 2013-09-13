#!/usr/bin/perl

$count_cmd = 'emacs -Q -batch -l ~/.dotfiles/elisp/ctanis/package-load.el -e get-updatable-count 2>/dev/null |sed -e s/\"//g ';
$growl_cmd = 'growlnotify -t "emacs update" -a Emacs.app -s';

$msg = `$count_cmd`;
if ($msg > 0) {

  open GROWL, "|$growl_cmd" or die;
  print GROWL $msg;
  close GROWL;

}
# else  {
#   print STDERR "no updates\n";
# }
