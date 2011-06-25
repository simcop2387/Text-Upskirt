/* perlrend.c - perl rendering interface */

/*
 * Copyright (c) 2011, Ryan Voots
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that it complies
 * with the Artistic 2.0 License as distributed in this bundle.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "markdown.h"
#include "html.h"
#include "buffer.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

#define PERLREND_START \
  dSP;                                          \
  SV *obj = (SV *) opaque;                      \
  SV *out;                                      \
  char *outstr;                                 \
  STRLEN len;                                      \
  int count;                                    \
                                                \
  /* setup the stack */                         \
  ENTER;                                        \
  SAVETMPS;                                     \
                                                \
  PUSHMARK(SP);                                 \
  XPUSHs(obj); 

#define PERLREND_END(XMETH)   PUTBACK;          \
                                                \
  count = call_method(#XMETH , G_SCALAR);       \
                                                \
  /* pull the stack off */                      \
  SPAGAIN;                                      \
                                                \
  if (!count)                                   \
    croak(#XMETH "failed to return a value");    \
                                                \
  out = POPs;                                   \
  outstr = sv_2pvbyte(out, &len);               \
  bufput(ob, outstr, len);                      \
                                                \
  PUTBACK;                                      \
  FREETMPS;                                     \
  LEAVE;                                        \
}


#define PERLREND_TXT(XMETH) \
  void perlrndr_ ##XMETH (struct buf *ob, struct buf *text, void *opaque) { \
  PERLREND_START \
  XPUSHs(sv_2mortal(newSVpv(text->data, text->size))); \
  PERLREND_END(XMETH)

#define PERLREND_TXTTXT(XMETH) \
  void perlrndr_ ##XMETH (struct buf *ob, struct buf *text, struct buf *text2, void *opaque) { \
  PERLREND_START \
  XPUSHs(sv_2mortal(newSVpv(text->data, text->size))); \
  XPUSHs(sv_2mortal(newSVpv(text2->data, text2->size))); \
  PERLREND_END(XMETH)

#define PERLREND_TXTTXTTXT(XMETH) \
  void perlrndr_ ##XMETH (struct buf *ob, struct buf *text, struct buf *text2, struct buf *text3, void *opaque) { \
  PERLREND_START \
  XPUSHs(sv_2mortal(newSVpv(text->data, text->size))); \
  XPUSHs(sv_2mortal(newSVpv(text2->data, text2->size))); \
  XPUSHs(sv_2mortal(newSVpv(text3->data, text3->size))); \
  PERLREND_END(XMETH)

#define PERLREND_TXTINT(XMETH) \
  void perlrndr_ ##XMETH (struct buf *ob, struct buf *text, int numb, void *opaque) { \
  PERLREND_START \
  XPUSHs(sv_2mortal(newSVpv(text->data, text->size))); \
  XPUSHs(sv_2mortal(newSViv(numb))); \
  PERLREND_END(XMETH)

#define PERLREND_NONE(XMETH) \
  void perlrndr_ ##XMETH (struct buf *ob, void *opaque) { \
  PERLREND_START \
  PERLREND_END(XMETH)

PERLREND_TXTTXT(blockcode);
PERLREND_TXT(blockquote);
PERLREND_TXT(blockhtml);
PERLREND_TXTINT(header);
PERLREND_NONE(hrule);
PERLREND_TXTINT(list);
PERLREND_TXTINT(listitem);
PERLREND_TXT(paragraph);
PERLREND_TXT(table);
PERLREND_TXTINT(tablecell);
PERLREND_TXT(tablerow);

void perlrndr_autolink(struct buf *ob, struct buf *text, enum mkd_autolink type, void *opaque) { \
  PERLREND_START \
  XPUSHs(sv_2mortal(newSVpv(text->data, text->size))); \
  XPUSHs(sv_2mortal(newSViv(type))); \
  PERLREND_END(autolink)

PERLREND_TXT(codespan);
PERLREND_TXT(double_emphasis);
PERLREND_TXT(emphasis);
PERLREND_TXTTXTTXT(image);
PERLREND_NONE(linebreak);
PERLREND_TXTTXTTXT(link);
PERLREND_TXT(raw_html_tag);
PERLREND_TXT(triple_emphasis);
PERLREND_TXT(strikethrough);
PERLREND_TXT(entity);
PERLREND_TXT(normal_text);
PERLREND_NONE(doc_header);
PERLREND_NONE(doc_footer);
