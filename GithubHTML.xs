#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "markdown.h"
#include "html.h"
#include "buffer.h"

#define GH_RNDR_START HV *selfhash = (HV *) SvRV(self); \
                         struct mkd_renderer *renderer; \
                         struct buf *ob = bufnew(128);

#define GH_RNDR_MIDDLE  SV **val = hv_fetchs(selfhash, "_html", 0); \
                        if (val == NULL) \
                          croak("Object contains no _html key, did you call the constructor?"); \
                        renderer = GithubHTML_SV_to_renderer(*val);

#define GH_RNDR_END RETVAL = newSVpv(ob->data, ob->size);          \
                    bufrelease(ob);

#define GH_RNDR_TXT(__meth) GH_RNDR_START \
                            struct buf *ib = bufnew(128); \
                            GH_RNDR_MIDDLE \
                            bufputs(ib, text); \
                                               \
                            renderer->__meth(ob, ib, renderer->opaque); \
                                        \
                            GH_RNDR_END \
                            bufrelease(ib);

#define GH_RNDR_TXTTXT(__meth) GH_RNDR_START \
                            struct buf *ib = bufnew(128); \
                            struct buf *ib2 = bufnew(128); \
                            GH_RNDR_MIDDLE \
                            bufputs(ib, text); \
                            bufputs(ib2, text2); \
                                               \
                            renderer->__meth(ob, ib, ib2, renderer->opaque); \
                                        \
                            GH_RNDR_END \
                            bufrelease(ib); \
                            bufrelease(ib2);

#define GH_RNDR_TXTTXTTXT(__meth) GH_RNDR_START \
                            struct buf *ib = bufnew(128); \
                            struct buf *ib2 = bufnew(128); \
                            struct buf *ib3 = bufnew(128); \
                            GH_RNDR_MIDDLE \
                            bufputs(ib, text); \
                            bufputs(ib2, text2); \
                            bufputs(ib3, text3); \
                                               \
                            renderer->__meth(ob, ib, ib2, ib3, renderer->opaque); \
                                        \
                            GH_RNDR_END \
                            bufrelease(ib); \
                            bufrelease(ib2); \
                            bufrelease(ib3);

#define GH_RNDR_TXTINT(__meth) GH_RNDR_START \
                            struct buf *ib = bufnew(128); \
                            GH_RNDR_MIDDLE \
                            bufputs(ib, text); \
                                               \
                            renderer->__meth(ob, ib, num, renderer->opaque); \
                                        \
                            GH_RNDR_END \
                            bufrelease(ib);

#define GH_RNDR_NONE(__meth) GH_RNDR_START \
                            GH_RNDR_MIDDLE \
                                               \
                            renderer->__meth(ob, renderer->opaque); \
                                        \
                            GH_RNDR_END

static struct mkd_renderer *
GithubHTML_SV_to_renderer(SV *const sv)
{
  return (struct mkd_renderer *)SvUV(sv);
}

SV *
GithubHTML_renderer_to_SV(struct mkd_renderer *render)
{
  SV *ret = newSVuv((UV) render);
  return ret;
}

// I know these next two AREN'T ideal, i just don't know how to do it better
MODULE = Text::Upskirt::Renderer::GithubHTML  PACKAGE = Text::Upskirt::Renderer::GithubHTML PREFIX = githubhtml_

SV *githubhtml__newrend(flags)
    int flags
    CODE:
      struct mkd_renderer *renderer = (struct mkd_renderer *) malloc(sizeof(struct mkd_renderer));
      SV *svrend = newSV(0);
      
      upshtml_renderer(renderer, flags);
      svrend = GithubHTML_renderer_to_SV(renderer);
      RETVAL = svrend;
      
    OUTPUT:
      RETVAL

void githubhtml__freerend(pointer)
    SV *pointer
    CODE:
        struct mkd_renderer *rend = GithubHTML_SV_to_renderer(pointer);
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
      GH_RNDR_TXTINT(autolink)

    OUTPUT:
      RETVAL

SV *githubhtml_codespan(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(codespan)

    OUTPUT:
      RETVAL

SV *githubhtml_double_emphasis(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(double_emphasis)

    OUTPUT:
      RETVAL

SV *githubhtml_emphasis(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(emphasis)

    OUTPUT:
      RETVAL

SV *githubhtml_image(self, text, text2, text3)
    SV *self
    char *text
    char *text2
    char *text3
    CODE:
      GH_RNDR_TXTTXTTXT(image)

    OUTPUT:
      RETVAL

SV *githubhtml_linebreak(self)
    SV *self
    CODE:
      GH_RNDR_NONE(linebreak)

    OUTPUT:
      RETVAL

SV *githubhtml_link(self, text, text2, text3)
    SV *self
    char *text
    char *text2
    char *text3
    CODE:
      GH_RNDR_TXTTXTTXT(link)

    OUTPUT:
      RETVAL

SV *githubhtml_raw_html_tag(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(raw_html_tag)

    OUTPUT:
      RETVAL

SV *githubhtml_triple_emphasis(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(triple_emphasis)

    OUTPUT:
      RETVAL

SV *githubhtml_strikethrough(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(strikethrough)

    OUTPUT:
      RETVAL

SV *githubhtml_normal_text(self, text)
    SV *self
    char *text
    CODE:
      GH_RNDR_TXT(normal_text)

    OUTPUT:
      RETVAL