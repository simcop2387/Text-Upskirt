#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "dump.h"

void DoDump(SV *dumpme) {
  dSP;

  PUSHMARK(SP);
  XPUSHs(dumpme);
  PUTBACK;

  call_pv("Devel::Peek::Dump", G_DISCARD);
}