#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <extern/src/markdown.h>

#include "const-c.inc"

MODULE = Text::Upskirt::Markdown		PACKAGE = Text::Upskirt::Markdown		

INCLUDE: const-xs.inc
