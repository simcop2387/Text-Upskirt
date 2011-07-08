#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "markdown.h"
#include "html.h"
#include "buffer.h"

#define GH_RNDR_START HV *selfhash = (HV *) SvRV(self); \
                         struct mkd_renderer *gitrend = GithubHTML_get__html(self); \
                         struct buf *ob = bufnew(1);

#define GH_RNDR_END(__meth) RETVAL = newSVpv(ob->data, ob->size);          \
                            bufrelease(ob);

#define GH_RNDR_TXT(__meth) GH_RNDR_START \
                            struct buf *ib = bufnew(1); \
                            bufputs(ib, text); \
                            gitrend->__meth(ob, ib, gitrend->opaque); \
                            GH_RNDR_END(__meth) \
                            bufrelease(ib);

#define GH_RNDR_TXTTXT(__meth) GH_RNDR_START \
                            struct buf *ib = bufnew(1); \
                            struct buf *ib2 = bufnew(1); \
                            bufputs(ib, text); \
                            bufputs(ib2, text2); \
                            gitrend->__meth(ob, ib, ib2, gitrend->opaque); \
                            GH_RNDR_END(__meth) \
                            bufrelease(ib); \
                            bufrelease(ib2);

#define GH_RNDR_TXTTXTTXT(__meth) GH_RNDR_START \
                            struct buf *ib = bufnew(1); \
                            struct buf *ib2 = bufnew(1); \
                            struct buf *ib3 = bufnew(1); \
                            bufputs(ib, text); \
                            bufputs(ib2, text2); \
                            bufputs(ib3, text3); \
                            gitrend->__meth(ob, ib, ib2, ib3, gitrend->opaque); \
                            GH_RNDR_END(__meth) \
                            bufrelease(ib); \
                            bufrelease(ib2); \
                            bufrelease(ib3);

#define GH_RNDR_TXTINT(__meth) GH_RNDR_START \
                            struct buf *ib = bufnew(1); \
                            bufputs(ib, text); \
                            gitrend->__meth(ob, ib, num, gitrend->opaque); \
                            GH_RNDR_END(__meth) \
                            bufrelease(ib);

#define GH_RNDR_NONE(__meth) GH_RNDR_START \
                            gitrend->__meth(ob, gitrend->opaque); \
                            GH_RNDR_END(__meth)

#define GH_RNDR_INT_START HV *selfhash = (HV *) SvRV(self); \
                          struct mkd_renderer *gitrend = GithubHTML_get__html(self); \
                          struct buf *ob = bufnew(1); \
                          int methret;

#define GH_RNDR_INT_END(__meth) if (methret) {\
                          RETVAL = newSVpv(ob->data, ob->size);          \
                        } else \
                          RETVAL = &PL_sv_undef; \
                        bufrelease(ob);

#define GH_RNDR_INT_TXT(__meth) GH_RNDR_INT_START \
                            struct buf *ib = bufnew(1); \
                            bufputs(ib, text); \
                            methret = gitrend->__meth(ob, ib, gitrend->opaque); \
                            GH_RNDR_INT_END(__meth) \
                            bufrelease(ib);

#define GH_RNDR_INT_TXTTXT(__meth) GH_RNDR_INT_START \
                            struct buf *ib = bufnew(1); \
                            struct buf *ib2 = bufnew(1); \
                            bufputs(ib, text); \
                            bufputs(ib2, text2); \
                            methret = gitrend->__meth(ob, ib, ib2, gitrend->opaque); \
                            GH_RNDR_INT_END(__meth) \
                            bufrelease(ib); \
                            bufrelease(ib2);

#define GH_RNDR_INT_TXTTXTTXT(__meth) GH_RNDR_INT_START \
                            struct buf *ib = bufnew(1); \
                            struct buf *ib2 = bufnew(1); \
                            struct buf *ib3 = bufnew(1); \
                            bufputs(ib, text); \
                            bufputs(ib2, text2); \
                            bufputs(ib3, text3); \
                            methret = gitrend->__meth(ob, ib, ib2, ib3, gitrend->opaque); \
                            GH_RNDR_INT_END(__meth) \
                            bufrelease(ib); \
                            bufrelease(ib2); \
                            bufrelease(ib3);

#define GH_RNDR_INT_TXTINT(__meth) GH_RNDR_INT_START \
                            struct buf *ib = bufnew(1); \
                            bufputs(ib, text); \
                            methret = gitrend->__meth(ob, ib, num, gitrend->opaque); \
                            GH_RNDR_INT_END(__meth) \
                            bufrelease(ib);

#define GH_RNDR_INT_NONE(__meth) GH_RNDR_INT_START \
                            methret = gitrend->__meth(ob, gitrend->opaque); \
                            GH_RNDR_INT_END(__meth)

int GithubHTML_get_flags(SV *const self) {
  SV *flags;
  int count;

  dSP;

  PUSHMARK(SP);
  XPUSHs(self);
  PUTBACK;

  count = call_method("flags", G_SCALAR);

  if (!count)
    croak("Failed to get flags");

  flags = POPs;
  //printf("GITHUB: Flags\n");

  if (SvOK(flags))
    return (int) SvIV(flags);
  else
    croak("Invalid flags");
}

void GithubHTML_set__html(SV *const self, void *_html) {
  SV *html = newSVuv((UV) _html);
  
  dSP;

  ////printf("Github_set__html\n");
  
  PUSHMARK(SP);
  XPUSHs(self);
  XPUSHs(html);
  PUTBACK;

  call_method("_html", G_DISCARD);
}

void *GithubHTML_get__html(SV *self) {
  SV *opaque;
  int count;

  dSP;

  PUSHMARK(SP);
  XPUSHs(self);
  PUTBACK;

  //printf("Github_get__html\nself = \n");
  //DoDump(self);

  
  count = call_method("_html", G_SCALAR);

  if (!count)
    croak("Failed to get GithubHTML data");

  opaque = POPs;

  //printf("_html = \n");
  //DoDump(opaque);
  
  if (SvOK(opaque))
    return (void *)SvUV(opaque);
  else
    croak("Invalid GithubHTML data");

  return NULL; // how the fuck did we get here?
}

// I know these next two AREN'T ideal, i just don't know how to do it better
MODULE = Text::Upskirt::Renderer::GithubHTML PACKAGE = Text::Upskirt::Renderer::GithubHTML PREFIX = githubhtml_

void githubhtml_BUILD(self, ...)
    SV *self
    CODE:
      struct mkd_renderer *htmlrend= (struct mkd_renderer *) malloc(sizeof(struct mkd_renderer));
                          
      int flags = GithubHTML_get_flags(self);
      
      upshtml_renderer(htmlrend, flags);
      GithubHTML_set__html(self, htmlrend);

void githubhtml_DESTROY(self)
    SV *self
    CODE:
        void *rend = GithubHTML_get__html(self);
        free(rend);

SV *githubhtml_blockcode(self, text, text2)
    SV *self
    char *text
    char *text2
    CODE:
      GH_RNDR_TXTTXT(blockcode)

    OUTPUT:
      RETVAL

SV *githubhtml_blockhtml(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(blockhtml)

    OUTPUT:
      RETVAL

SV *githubhtml_header(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      GH_RNDR_TXTINT(header)

    OUTPUT:
      RETVAL

SV *githubhtml_hrule(self)
    SV *self
    CODE:
      GH_RNDR_NONE(hrule)

    OUTPUT:
      RETVAL

SV *githubhtml_list(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      GH_RNDR_TXTINT(list)

    OUTPUT:
      RETVAL

SV *githubhtml_listitem(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      GH_RNDR_TXTINT(listitem)

    OUTPUT:
      RETVAL

SV *githubhtml_paragraph(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(paragraph)
      
    OUTPUT:
      RETVAL

SV *githubhtml_table(self, text, text2)
    SV *self
    char *text
    char *text2
    CODE:
      GH_RNDR_TXTTXT(table)

    OUTPUT:
      RETVAL

SV *githubhtml_table_row(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(table_row)

    OUTPUT:
      RETVAL

SV *githubhtml_table_cell(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      GH_RNDR_TXTINT(table_cell)

    OUTPUT:
      RETVAL

SV *githubhtml_autolink(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      // This may have a bug on other platforms given that this SHOULD be an enum, i'm hoping the compiler will DWIM and not give a fuck
      GH_RNDR_INT_TXTINT(autolink)

    OUTPUT:
      RETVAL

SV *githubhtml_codespan(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_INT_TXT(codespan)

    OUTPUT:
      RETVAL

SV *githubhtml_double_emphasis(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_INT_TXT(double_emphasis)

    OUTPUT:
      RETVAL

SV *githubhtml_emphasis(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_INT_TXT(emphasis)

    OUTPUT:
      RETVAL

SV *githubhtml_image(self, text, text2, text3)
    SV *self
    char *text
    char *text2
    char *text3
    CODE:
      GH_RNDR_INT_TXTTXTTXT(image)

    OUTPUT:
      RETVAL

SV *githubhtml_linebreak(self)
    SV *self
    CODE:
      GH_RNDR_INT_NONE(linebreak)

    OUTPUT:
      RETVAL

SV *githubhtml_link(self, text, text2, text3)
    SV *self
    char *text
    char *text2
    char *text3
    CODE:
      GH_RNDR_INT_TXTTXTTXT(link)

    OUTPUT:
      RETVAL

SV *githubhtml_raw_html_tag(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_INT_TXT(raw_html_tag)

    OUTPUT:
      RETVAL

SV *githubhtml_triple_emphasis(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_INT_TXT(triple_emphasis)

    OUTPUT:
      RETVAL

SV *githubhtml_strikethrough(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_INT_TXT(strikethrough)

    OUTPUT:
      RETVAL

SV *githubhtml_normal_text(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(normal_text)

    OUTPUT:
      RETVAL