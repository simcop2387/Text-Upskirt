# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Text-Upskirt-Markdown.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 2;
BEGIN { use_ok('Text::Upskirt::Markdown') };


my $fail = 0;
foreach my $constname (qw(
	MKDA_EMAIL MKDA_NORMAL MKDA_NOT_AUTOLINK MKDEXT_AUTOLINK
	MKDEXT_FENCED_CODE MKDEXT_LAX_HTML_BLOCKS MKDEXT_NO_INTRA_EMPHASIS
	MKDEXT_SPACE_HEADERS MKDEXT_STRIKETHROUGH MKDEXT_TABLES
	MKD_LIST_ORDERED MKD_LI_BLOCK MKD_TABLE_ALIGN_CENTER MKD_TABLE_ALIGN_L
	MKD_TABLE_ALIGN_R UPSKIRT_VER_MAJOR UPSKIRT_VER_MINOR
	UPSKIRT_VER_REVISION)) {
  next if (eval "my \$a = $constname; 1");
  if ($@ =~ /^Your vendor has not defined Text::Upskirt::Markdown macro $constname/) {
    print "# pass: $@";
  } else {
    print "# fail: $@";
    $fail = 1;
  }

}

ok( $fail == 0 , 'Constants' );
#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $in = << 'EOF';
Testing
=======

* Foo
* Bar
EOF

my $out = Text::Upskirt::Markdown::markdown($in);
ok($out ne "");
