#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "markdown.h"
#include "html.h"
#include "buffer.h"
#include "perlrend.h"

#include "const-c.inc"

struct mkd_renderer *TU_get_rendp(SV *const self) {
  SV *_rendp;
  int count;

  dSP;

  PUSHMARK(SP);
  XPUSHs(self);
  PUTBACK;

  count = call_method("_rendp", G_SCALAR);

  if (!count)
    croak("Failed to get rendering context");

  _rendp = POPs;

  if (SvOK(_rendp))
    return (struct mkd_renderer *)SvUV(_rendp);
  else
    croak("Invalid rendering context");

  return NULL; // how the fuck did we get here?
}


MODULE = Text::Upskirt		PACKAGE = Text::Upskirt

INCLUDE: const-xs.inc

BOOT:
boot_Text__Upskirt__Renderer(aTHX_ cv);
boot_Text__Upskirt__Renderer__GithubHTML(aTHX_ cv);
      
SV *markdown_default(input, extens = 0, html = 0)
    char *input
    unsigned int extens
    unsigned int html
    CODE:
       struct mkd_renderer renderer;
       struct buf *ib, *ob;
       SV *out;

       ib = bufnew(1024);
       ob = bufnew(64);
       bufputs(ib, input);
       upshtml_renderer(&renderer, html);
       ups_markdown(ob, ib, &renderer, extens);
       upshtml_free_renderer(&renderer);
       out = newSVpv(ob->data, ob->size);
       bufrelease(ib);
       bufrelease(ob);
       RETVAL = out;

    OUTPUT:
      RETVAL

SV *markdown_custom(perlrend, input, extens = 0)
    SV *perlrend;
    char *input
    unsigned int extens
    CODE:
       struct mkd_renderer *renderer;
       struct buf *ib, *ob;
       SV *out;

       renderer = TU_get_rendp(perlrend);
       renderer->opaque = perlrend; // fix up the pointer?
       //printf("perlrend: %08X %08X %04X\n", perlrend, renderer, extens);

       ib = bufnew(1024);
       ob = bufnew(64);
       bufputs(ib, input);
       ups_markdown(ob, ib, renderer, extens);
       out = newSVpv(ob->data, ob->size);
       bufrelease(ib);
       bufrelease(ob);
       RETVAL = out;

    OUTPUT:
      RETVAL

SV *smartypants(input)
    char *input
    CODE:
       struct buf *ib, *ob;
       SV *out;

       ib = bufnew(1024);
       ob = bufnew(64);
       bufputs(ib, input);
       upshtml_smartypants(ob, ib);
       out = newSVpv(ob->data, ob->size);
       bufrelease(ib);
       bufrelease(ob);
       RETVAL = out;

    OUTPUT:
      RETVAL
