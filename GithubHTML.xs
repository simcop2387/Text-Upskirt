#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "markdown.h"
#include "html.h"
#include "buffer.h"

static struct mkd_renderer *
GithubHTML_SV_to_renderer(SV *const sv)
{
  return SvUV(sv);
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
      struct mkd_renderer *renderer;
      SV *svrend = newSV(0);

      Newx(renderer, 1, struct mkd_renderer);
      
      upshtml_renderer(renderer, flags);
      svrend = GithubHTML_renderer_to_SV(renderer);
      RETVAL = svrend;
      
    OUTPUT:
      RETVAL

void githubhtml__freerend(pointer)
    SV *pointer
    CODE:
        struct mkd_renderer *rend = GithubHTML_SV_to_renderer(pointer);
        Safefree(rend);

SV *githubhtml_paragraph(self, text)
    SV *self
    char *text
    CODE:
      HV *selfhash = (HV *) SvRV(self); // deref ourselves
      struct mkd_renderer *renderer;

      SV **val = hv_fetchs(selfhash, "_html", 0);
      SV *rendsv;
      if (val == NULL)
        croak("WTF no _html key?");

      rendsv = *val;
      RETVAL = rendsv;
      
    OUTPUT:
      RETVAL