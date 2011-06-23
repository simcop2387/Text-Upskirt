#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "markdown.h"
#include "html.h"
#include "buffer.h"

#include "const-c.inc"

MODULE = Text::Upskirt::Markdown		PACKAGE = Text::Upskirt::Markdown		

INCLUDE: const-xs.inc

  char *markdown(input)
    char &input
    CODE:
       struct mkd_renderer renderer;
       struct buf *ib, *ob;

       ib = bufnew(1024);
       ob = bufnew(64);
       bufputs(ib, input);

/*       upshtml_renderer(&renderer, 0);
       ups_markdown(ob, ib, &renderer, ~0);
       upshtml_free_renderer(&renderer); */

    OUTPUT:
      RETVAL
