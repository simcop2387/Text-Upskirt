package Text::Upskirt::Renderer::GithubHTML;

use strict;
use warnings;

use Text::Upskirt; # bootstraps Bar.xs
use Text::Upskirt::Renderer;
use base 'Text::Upskirt::Renderer';

sub new {
  my ($class, $flags) = @_;
  # more of that same issue
  no warnings 'uninitialized';
  my $pointer = _newrend($flags);

  bless {_html => $pointer};
}

1;