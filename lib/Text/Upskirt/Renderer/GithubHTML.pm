package Text::Upskirt::Renderer::GithubHTML;

use strict;
use warnings;

use Text::Upskirt; # bootstraps Bar.xs
use Text::Upskirt::Renderer;
use Devel::Peek;

use Moose;

extends 'Text::Upskirt::Renderer';

has 'flags' => (is => 'ro');
has '_html' => (is => 'rw');

1;