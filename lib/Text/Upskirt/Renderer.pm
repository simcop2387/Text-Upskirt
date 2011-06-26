package Text::Upskirt::Renderer;

use strict;
use warnings;

sub new {
  bless {}; # nothing fancy for us thank you very much!
}

sub blockcode {
  my ($self, $code, $lang) = @_;
  return "[$lang] $code";
}

sub blockquote {
  my ($self, $text) = @_;
  return $text;
}

sub blockhtml {
  my ($self, $html) = @_;
  return $html;
}

sub header {
  my ($self, $text) = @_;
  return $text;
}

sub hrule {
  my ($self) = @_;
  return "------";
}

sub list {
  my ($self, $text, $flags) = @_;
  return $text;
}

sub listitem {
  my ($self, $text, $flags) = @_;
  return $text;
}

sub paragraph {
  my ($self, $text) = @_;
  return $text;
}

sub table {
  my ($self, $header, $body) = @_;
  return "$header\n$body";
}

sub table_row {
  my ($self, $text) = @_;
  return $text;
}

sub table_cell {
  my ($self, $text, $flags) = @_;
  return $text;
}

sub autolink {
  my ($self, $link, $type) = @_;
  return $link;
}

sub codespan {
  my ($self, $text) = @_;
  return $text;
}

sub double_emphasis {
  my ($self, $text) = @_;
  return $text;
}

sub emphasis {
  my ($self, $text) = @_;
  return $text;
}

sub image {
  my ($self, $link, $title, $alt) = @_;
  return $link;
}

sub linebreak {
  my ($self) = @_;
  return "\n";
}

sub raw_html_tag {
  my ($self, $html) = @_;
  return $html;
}

sub triple_emphasis {
  my ($self, $text) = @_;
  return $text;
}

sub strikethrough {
  my ($self, $text) = @_;
  return $text;
}

sub entity {
  my ($self, $text) = @_;
  return $text;
}

sub normal_text {
  my ($self, $text) = @_;
  return $text;
}

sub doc_header {
  my ($self) = @_;
  return;
}

sub doc_footer {
  my ($self) = @_;
  return;
}

1;
__END__;
=head1 DOCS GO HERE
DOCS GO HERE!