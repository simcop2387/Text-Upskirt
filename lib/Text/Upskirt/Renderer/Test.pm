package Text::Upskirt::Renderer::Test;

use strict;
use warnings;

use Moose;
use Devel::Peek;

extends 'Text::Upskirt::Renderer';

sub blockcode {
  my ($self, $code, $lang) = @_;
  return "<blockcode lang='$lang'>$code</blockcode>\n";
}

sub blockquote {
  my ($self, $text) = @_;
  return "<blockquote>$text</blockquote>\n";
}

sub blockhtml {
  my ($self, $html) = @_;
  return "<blockhtml>$html</blockhtml>\n";
}

sub header {
  my ($self, $text, $level) = @_;
  return "<header level='$level'>$text</header>\n";
}

sub hrule {
  my ($self) = @_;
  return "<hrule />\n";
}

sub list {
  my ($self, $text, $flags) = @_;
  return "<list flags='$flags'>$text</list>\n";
}

sub listitem {
  my ($self, $text, $flags) = @_;
  return "<listitem flags='$flags'>$text</listitem>\n";
}

sub paragraph {
  my ($self, $text) = @_;
  return "<paragrah>$text</paragraph>\n";
}

sub table {
  my ($self, $header, $body) = @_;
  return "<table><header>$header</header><body>$body</body></table>\n";
}

sub table_row {
  my ($self, $text) = @_;
  return "<table_row>$text</table_row>\n";
}

sub table_cell {
  my ($self, $text, $flags) = @_;
  return "<table_cell flags='$flags'>$text</table_cell>\n";
}

sub autolink {
  my ($self, $link, $type) = @_;
  return "<autolink type='$type'>$link</autolink>\n";
}

sub codespan {
  my ($self, $text) = @_;
  return "<codespan>$text</codespan>\n";
}

sub double_emphasis {
  my ($self, $text) = @_;
  return "<double_emphasis>$text</double_emphasis>\n";
}

sub emphasis {
  my ($self, $text) = @_;
  return "<emphasis>$text</emphasis>\n";
}

sub image {
  my ($self, $link, $title, $alt) = @_;
  return "<image title='$title' alt='$alt'>$link</image>\n";
}

sub link {
  my ($self, $link, $title, $alt) = @_;
  return "<link title='$title' alt='$alt'>$link</link>\n";
}

sub linebreak {
  my ($self) = @_;
  return "<linebreak />\n";
}

sub raw_html_tag {
  my ($self, $html) = @_;
  return "<raw_html_tag>'$html'</raw_html_tag>\n";
}

sub triple_emphasis {
  my ($self, $text) = @_;
  return "<triple_emphasis>$text</triple_emphasis>\n";
}

sub strikethrough {
  my ($self, $text) = @_;
  return "<strikethrough>$text</strikethrough>\n";
}

sub entity {
  my ($self, $text) = @_;
  return "<entity>$text</entity>\n";
}

sub normal_text {
  my ($self, $text) = @_;
  return $text;
}

sub doc_header {
  my ($self) = @_;
  return "<doc_header />\n";
}

sub doc_footer {
  my ($self) = @_;
  return "<doc_footer />\n";
}

1;
__END__;
=head1 DOCS GO HERE
DOCS GO HERE!