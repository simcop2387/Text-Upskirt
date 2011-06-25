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

#include "markdown.h"
#include "html.h"
#include "buffer.h"
#include "ppport.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

void blockcode(struct buf *ob, struct buf *text, struct *lang, void *opaque) {
  dSP; // declare local stack pointer
  SV *obj = (SV *) opaque;
  SV *out;
  char *outstr;
  int len;
  int count;

  /* setup the stack */
  ENTER;
  SAVETMPS;

  PUSH_MARK(SP);
  XPUSHs(obj);
  XPUSHs(sv_2mortal(newSVpv(text->data, text->size)));
  XPUSHs(sv_2mortal(newSVpv(lang->data, lang->size)));
  PUTBACK;

  count = call_method("blockcode", G_SCALAR);

  /* pull the stack off */
  SPAGAIN;

  if (!count)
    croak("blockcode failed to return a value");

  out = POPs;
  outstr = sv_2pvbyte(out, &len);
  bufput(ob, outstr, len);
  
  PUTBACK;  
  FREETMPS;
  LEAVE;
}