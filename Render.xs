#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "markdown.h"
#include "html.h"
#include "buffer.h"
#include "perlrend.h"

#define CAN(method) if (!docan(self, #method)) {rendp->method = NULL;}

int docan(SV *self, char *method) {
  SV *out;
  int count;    
  dSP;
  
  ENTER;
  SAVETMPS;

  PUSHMARK(SP);
  XPUSHs(self);
  XPUSHs(sv_2mortal(newSVpv(method,0)));
  PUTBACK;

  count = call_method("can", G_SCALAR); // we can't die!

  SPAGAIN;
  if (!count) {
    //printf("SUCK IT %s\n", method);
    return 0; // if we didn't get anything then we can't do that method, duh
  }

  out = POPs;
  if (SvOK(out)) {
    return 1;
  } else {
    return 0;
  };
}

struct mkd_renderer *TUR_get__rendp(SV *const self) {
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

  //printf("RenderXS: %08X %08X\n", self, SvUV(_rendp));

  if (SvOK(_rendp))
    return (struct mkd_renderer *)SvUV(_rendp);
  else
    croak("Invalid rendering context");

  return NULL; // how the fuck did we get here?
}

// I know these next two AREN'T ideal, i just don't know how to do it better
MODULE = Text::Upskirt::Renderer PACKAGE = Text::Upskirt::Renderer PREFIX = tur_

void tur_BUILD(self, ...)
  SV *self
  CODE:
    struct mkd_renderer *rendp = malloc(sizeof(struct mkd_renderer));
    *rendp = perlrender_markdown;
    //printf("INBUILD: %08X %08X\n", self, rendp);
    CAN(blockcode);
    CAN(blockquote);
    CAN(blockhtml);
    CAN(header);
    CAN(hrule);
    CAN(list);
    CAN(listitem);
    CAN(paragraph);
    CAN(table);
    CAN(table_row);
    CAN(table_cell);
    CAN(autolink);
    CAN(codespan);
    CAN(double_emphasis);
    CAN(emphasis);
    CAN(image);
    CAN(linebreak);
    CAN(link);
    CAN(raw_html_tag);
    CAN(triple_emphasis);
    CAN(strikethrough);
    CAN(entity);
    CAN(normal_text);
    CAN(doc_header);
    CAN(doc_footer);

    rendp->opaque = (void *) self;

    PUSHMARK(SP);
    XPUSHs(self);
    XPUSHs(newSVuv((UV) rendp));
    PUTBACK;

    call_method("_rendp", G_DISCARD);

    //printf("INBUILD2: %08X %08X %08X\n", self, rendp, TUR_get__rendp(self));
    

void tur_DESTROY(self)
    SV *self
    CODE:
        void *rendp = TUR_get__rendp(self);
        free(rendp);
