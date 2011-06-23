package Text::Upskirt;
    # ABSTRACT: turns baubles into trinkets

use strict;
use warnings;
use 5.012003;
use Carp;

use constant {HTML_SKIP_HTML => (1 << 0),
             HTML_SKIP_STYLE => (1 << 1),
             HTML_SKIP_IMAGES => (1 << 2),
             HTML_SKIP_LINKS => (1 << 3),
             HTML_EXPAND_TABS => (1 << 5),
             HTML_SAFELINK => (1 << 7),
             HTML_TOC => (1 << 8),
             HTML_HARD_WRAP => (1 << 9),
             HTML_GITHUB_BLOCKCODE => (1 << 10),
             HTML_USE_XHTML => (1 << 11)};

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
	MKDEXT_AUTOLINK
	MKDEXT_FENCED_CODE
	MKDEXT_LAX_HTML_BLOCKS
	MKDEXT_NO_INTRA_EMPHASIS
	MKDEXT_SPACE_HEADERS
	MKDEXT_STRIKETHROUGH
	MKDEXT_TABLES
        HTML_SKIP_HTML
        HTML_SKIP_STYLE
        HTML_SKIP_IMAGES
        HTML_SKIP_LINKS
        HTML_EXPAND_TABS
        HTML_SAFELINK
        HTML_TOC
        HTML_HARD_WRAP
        HTML_GITHUB_BLOCKCODE
        HTML_USE_XHTML
) ],
 'ext' => [ qw (
        MKDEXT_AUTOLINK
        MKDEXT_FENCED_CODE
        MKDEXT_LAX_HTML_BLOCKS
        MKDEXT_NO_INTRA_EMPHASIS
        MKDEXT_SPACE_HEADERS
        MKDEXT_STRIKETHROUGH
        MKDEXT_TABLES
)],
 'html' => [ qw (
        HTML_SKIP_HTML
        HTML_SKIP_STYLE
        HTML_SKIP_IMAGES
        HTML_SKIP_LINKS
        HTML_EXPAND_TABS
        HTML_SAFELINK
        HTML_TOC
        HTML_HARD_WRAP
        HTML_GITHUB_BLOCKCODE
        HTML_USE_XHTML
)],

 );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	MKDEXT_AUTOLINK
	MKDEXT_FENCED_CODE
	MKDEXT_LAX_HTML_BLOCKS
	MKDEXT_NO_INTRA_EMPHASIS
	MKDEXT_SPACE_HEADERS
	MKDEXT_STRIKETHROUGH
	MKDEXT_TABLES
        HTML_SKIP_HTML
        HTML_SKIP_STYLE
        HTML_SKIP_IMAGES
        HTML_SKIP_LINKS
        HTML_EXPAND_TABS
        HTML_SAFELINK
        HTML_TOC
        HTML_HARD_WRAP
        HTML_GITHUB_BLOCKCODE
        HTML_USE_XHTML
);


sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Text::Upskirt::constant not defined" if $constname eq 'constant';
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
XSLoader::load('Text::Upskirt', $Text::Upskirt::VERSION);

# Preloaded methods go here.

# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__
