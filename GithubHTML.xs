#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "embed.h"

#include "markdown.h"
#include "html.h"
#include "buffer.h"

int GithubHTML_get_flags(SV *const self) {
  SV *flags;
  int count;

  dSP;

  PUSHMARK(SP);
  XPUSHs(self);
  PUTBACK;

  count = call_method("flags", G_SCALAR);

  SPAGAIN;

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

  SPAGAIN;

  if (!count)
    croak("Failed to get GithubHTML data");

  opaque = POPs;

  //printf("_html = \n");
  //DoDump(opaque);
  
  if (SvOK(opaque))
    return (void *)SvUV(opaque);
  else
    croak("Invalid GithubHTML data");

  PUTBACK;
  FREETMPS;
  LEAVE;
  
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
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      struct buf *ib2 = bufnew(1);
      bufputs(ib, text);
      bufputs(ib2, text2);
      gitrend->blockcode(ob, ib, ib2, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);
      bufrelease(ib2);

    OUTPUT:
      RETVAL

SV *githubhtml_blockhtml(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      gitrend->blockhtml(ob, ib, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

SV *githubhtml_header(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      gitrend->header(ob, ib, num, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

SV *githubhtml_hrule(self)
    SV *self
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      gitrend->hrule(ob, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);

    OUTPUT:
      RETVAL

SV *githubhtml_list(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      gitrend->list(ob, ib, num, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

SV *githubhtml_listitem(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      gitrend->listitem(ob, ib, num, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

SV *githubhtml_paragraph(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      gitrend->paragraph(ob, ib, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);
      
    OUTPUT:
      RETVAL

SV *githubhtml_table(self, text, text2)
    SV *self
    char *text
    char *text2
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      struct buf *ib2 = bufnew(1);
      bufputs(ib, text);
      bufputs(ib2, text2);
      gitrend->table(ob, ib, ib2, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);
      bufrelease(ib2);

    OUTPUT:
      RETVAL

SV *githubhtml_table_row(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      gitrend->table_row(ob, ib, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

SV *githubhtml_table_cell(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      gitrend->table_cell(ob, ib, num, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

AV *githubhtml_autolink(self, text, num)
    SV *self
    char *text
    int num
    CODE:
      // This may have a bug on other platforms given that this SHOULD be an enum, i'm hoping the compiler will DWIM and not give a fuck
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      methret = gitrend->autolink(ob, ib, num, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

AV *githubhtml_codespan(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      methret = gitrend->codespan(ob, ib, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

AV *githubhtml_double_emphasis(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      methret = gitrend->double_emphasis(ob, ib, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

AV *githubhtml_emphasis(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      methret = gitrend->emphasis(ob, ib, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

AV *githubhtml_image(self, text, text2, text3)
    SV *self
    char *text
    char *text2
    char *text3
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      struct buf *ib = bufnew(1);
      struct buf *ib2 = bufnew(1);
      struct buf *ib3 = bufnew(1);
      bufputs(ib, text);
      bufputs(ib2, text2);
      bufputs(ib3, text3);
      methret = gitrend->image(ob, ib, ib2, ib3, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);
      bufrelease(ib);
      bufrelease(ib2);
      bufrelease(ib3);

    OUTPUT:
      RETVAL

AV *githubhtml_linebreak(self)
    SV *self
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      methret = gitrend->linebreak(ob, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);

    OUTPUT:
      RETVAL

AV *githubhtml_link(self, text, text2, text3)
    SV *self
    char *text
    char *text2
    char *text3
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      struct buf *ib = bufnew(1);
      struct buf *ib2 = bufnew(1);
      struct buf *ib3 = bufnew(1);
      bufputs(ib, text);
      bufputs(ib2, text2);
      bufputs(ib3, text3);
      methret = gitrend->link(ob, ib, ib2, ib3, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);
      bufrelease(ib);
      bufrelease(ib2);
      bufrelease(ib3);

    OUTPUT:
      RETVAL

AV *githubhtml_raw_html_tag(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      methret = gitrend->raw_html_tag(ob, ib, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

AV *githubhtml_triple_emphasis(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      methret = gitrend->triple_emphasis(ob, ib, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

AV *githubhtml_strikethrough(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      int methret;
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      methret = gitrend->strikethrough(ob, ib, gitrend->opaque);
      RETVAL = newAV();
      sv_2mortal((SV*)RETVAL);
      av_push(RETVAL, sv_2mortal(newSVpv(ob->data, ob->size)));
      av_push(RETVAL, sv_2mortal(newSViv(methret)));
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL

SV *githubhtml_normal_text(self, text)
    SV *self
    char *text
    CODE:
      struct mkd_renderer *gitrend = GithubHTML_get__html(self);
      struct buf *ob = bufnew(1);
      struct buf *ib = bufnew(1);
      bufputs(ib, text);
      gitrend->normal_text(ob, ib, gitrend->opaque);
      RETVAL = newSVpv(ob->data, ob->size);
      bufrelease(ob);
      bufrelease(ib);

    OUTPUT:
      RETVAL