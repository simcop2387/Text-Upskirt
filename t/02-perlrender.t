# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Text-Upskirt-Markdown.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use strict;
use warnings;

use Data::Dumper;

use Test::More tests => 4;
BEGIN { use_ok('Text::Upskirt'); use_ok('Text::Upskirt::Renderer'); };

{package Text::Upskirt::Renderer::Strip;
 use Moose;
 extends 'Text::Upskirt::Renderer';

 sub link {
   my ($self, $text, $text2, $text3) = @_;
   #print "$text :: $text2 :: $text3";
   return "link";
  }

 sub header {
   my ($self, $text) = @_;
   return $text;
 }

 sub list {
   my ($self, $text) = @_;
   return $text;
 }

 sub listitem {
   my ($self, $text) = @_;
   return $text;
 }

 sub normal_text {
   my ($self, $text) = @_;
   return $text;
 }
}

my $render = Text::Upskirt::Renderer::Strip->new();
ok(defined $render);

my $out = Text::Upskirt::markdown($render, << 'EOF');
My document
===========

* One
* Two
* Three
EOF

my $rend = << 'EOF';
My documentOne
Two
Three
EOF

ok($out eq $rend);

print $out;

# short basic test, to see if it works
