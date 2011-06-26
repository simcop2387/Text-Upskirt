package Text::Upskirt::Renderer::GithubHTML;

use strict;
use warnings;

use Text::Upskirt; # bootstraps Bar.xs

sub new {
  my ($class, $flags) = @_;
  # more of that same issue
  no warnings 'uninitialized';
  my $pointer = _newrend($flags);

  bless {_html => $pointer};
}

1;