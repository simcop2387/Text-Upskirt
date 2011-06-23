use strict;
use warnings;

package Text::Upskirt::Markdown;
    # ABSTRACT: turns baubles into trinkets

use 5.012003;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Text::Upskirt::Markdown ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	MKDA_EMAIL
	MKDA_NORMAL
	MKDA_NOT_AUTOLINK
	MKDEXT_AUTOLINK
	MKDEXT_FENCED_CODE
	MKDEXT_LAX_HTML_BLOCKS
	MKDEXT_NO_INTRA_EMPHASIS
	MKDEXT_SPACE_HEADERS
	MKDEXT_STRIKETHROUGH
	MKDEXT_TABLES
	MKD_LIST_ORDERED
	MKD_LI_BLOCK
	MKD_TABLE_ALIGN_CENTER
	MKD_TABLE_ALIGN_L
	MKD_TABLE_ALIGN_R
	UPSKIRT_VER_MAJOR
	UPSKIRT_VER_MINOR
	UPSKIRT_VER_REVISION
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	MKDA_EMAIL
	MKDA_NORMAL
	MKDA_NOT_AUTOLINK
	MKDEXT_AUTOLINK
	MKDEXT_FENCED_CODE
	MKDEXT_LAX_HTML_BLOCKS
	MKDEXT_NO_INTRA_EMPHASIS
	MKDEXT_SPACE_HEADERS
	MKDEXT_STRIKETHROUGH
	MKDEXT_TABLES
	MKD_LIST_ORDERED
	MKD_LI_BLOCK
	MKD_TABLE_ALIGN_CENTER
	MKD_TABLE_ALIGN_L
	MKD_TABLE_ALIGN_R
	UPSKIRT_VER_MAJOR
	UPSKIRT_VER_MINOR
	UPSKIRT_VER_REVISION
);

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Text::Upskirt::Markdown::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Text::Upskirt::Markdown', $Text::Upskirt::Markdown::VERSION);

# Preloaded methods go here.

# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__
