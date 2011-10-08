//#include "markdown.h"
//#include "html.h"
//#include "buffer.h"

//#include <string.h>
//#include <stdlib.h>
//#include <stdio.h>
//#include <ctype.h>

#define TRACE_START(XMETH) \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq);

#define TRACE_TXT(XMETH) \
  void trace_ ##XMETH (struct buf *ob, struct buf *text, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  printf("  INPUT: %.*s\n", text->size-1, text->data); \
  realrend->XMETH(ob, text, realopq); \
  }

#define TRACE_TXTTXT(XMETH) \
  void trace_ ##XMETH (struct buf *ob, struct buf *text, struct buf *text2, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  printf("  INPUT : %.*s\n", text->size-1, text->data); \
  printf("  INPUT2: %.*s\n", text2->size-1, text2->data); \
  realrend->XMETH(ob, text, text2, realopq); \
  }

#define TRACE_TXTTXTTXT(XMETH) \
  void trace_ ##XMETH (struct buf *ob, struct buf *text, struct buf *text2, struct buf *text3, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  printf("  INPUT : %.*s\n", text->size-1, text->data); \
  printf("  INPUT2: %.*s\n", text2->size-1, text2->data); \
  printf("  INPUT3: %.*s\n", text3->size-1, text3->data); \
  realrend->XMETH(ob, text, text2, text3, realopq); \
  }

#define TRACE_TXTINT(XMETH) \
  void trace_ ##XMETH (struct buf *ob, struct buf *text, int numb, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  printf("  INPUT : %.*s\n", text->size-1, text->data); \
  printf("  NUMBER: %d\n",   numb); \
  realrend->XMETH(ob, text, numb, realopq); \
  }

#define TRACE_NONE(XMETH) \
  void trace_ ##XMETH (struct buf *ob, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  realrend->XMETH(ob, realopq); \
  }


#define TRACE_INT_TXT(XMETH) \
  int trace_ ##XMETH (struct buf *ob, struct buf *text, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  int ret; \
  printf("  INPUT: %.*s\n", text->size-1, text->data); \
  ret = realrend->XMETH(ob, text, realopq); \
  printf("  RETURN: %d\n", ret); \
  return ret; \
  }

#define TRACE_INT_TXTTXT(XMETH) \
  int trace_ ##XMETH (struct buf *ob, struct buf *text, struct buf *text2, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  int ret; \
  printf("  INPUT : %.*s\n", text->size-1, text->data); \
  printf("  INPUT2: %.*s\n", text2->size-1, text2->data); \
  ret = realrend->XMETH(ob, text, text2, realopq); \
  printf("  RETURN: %d\n", ret); \
  return ret; \
  }

#define TRACE_INT_TXTTXTTXT(XMETH) \
  int trace_ ##XMETH (struct buf *ob, struct buf *text, struct buf *text2, struct buf *text3, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  int ret; \
  printf("  INPUT : %.*s\n", text->size-1, text->data); \
  printf("  INPUT2: %.*s\n", text2->size-1, text2->data); \
  printf("  INPUT3: %.*s\n", text3->size-1, text3->data); \
  ret = realrend->XMETH(ob, text, text2, text3, realopq); \
  printf("  RETURN: %d\n", ret); \
  return ret; \
  }
  
#define TRACE_INT_TXTINT(XMETH) \
  int trace_ ##XMETH (struct buf *ob, struct buf *text, int numb, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  int ret; \
  printf("  INPUT : %.*s\n", text->size-1, text->data); \
  printf("  NUMBER: %d\n",   numb); \
  ret = realrend->XMETH(ob, text, numb, realopq); \
  printf("  RETURN: %d\n", ret); \
  return ret; \
  }

#define TRACE_INT_NONE(XMETH) \
  int trace_ ##XMETH (struct buf *ob, void *opaque) { \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque; \
  void *realopq = realrend->opaque; \
  printf(">>" #XMETH " :: %08X -> %08X\n", opaque, realopq); \
  int ret; \
  ret = realrend->XMETH(ob, realopq); \
  printf("  RETURN: %d\n", ret); \
  return ret; \
  }

// block level
TRACE_TXTTXT(blockcode)
TRACE_TXT(blockquote)
TRACE_TXT(blockhtml)
TRACE_TXTINT(header)
TRACE_NONE(hrule)
/*  trace_hrule (struct buf *ob, void *opaque) {
  printf(">>" "hrule" "\n"); \
  struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
  void *realopq = realrend->opaque;
  realrend->hrule(ob, realopq);
  }*/

TRACE_TXTINT(list)
TRACE_TXTINT(listitem)
TRACE_TXT(paragraph)
TRACE_TXTTXT(table)
TRACE_TXTINT(table_cell)
TRACE_TXT(table_row)

// span level
TRACE_INT_TXTINT(autolink)
TRACE_INT_TXT(codespan)
TRACE_INT_TXT(double_emphasis)
TRACE_INT_TXT(emphasis)
TRACE_INT_TXTTXTTXT(image)
TRACE_INT_NONE(linebreak)
TRACE_INT_TXTTXTTXT(link)
TRACE_INT_TXT(raw_html_tag)
TRACE_INT_TXT(triple_emphasis)
TRACE_INT_TXT(strikethrough)

// low level
TRACE_TXT(entity)
TRACE_TXT(normal_text)
TRACE_NONE(doc_header)
TRACE_NONE(doc_footer)

#define CAN(XMETH) if (orig->XMETH) {new->XMETH = trace_ ##XMETH;}

// this leaks! will not fix

struct mkd_renderer *trace_wrap(struct mkd_renderer *orig) {
  struct mkd_renderer *new = malloc(sizeof(struct mkd_renderer));
  new->opaque = orig;

  printf("WRAPPING %08X\n", orig);

  CAN(blockcode);
  CAN(blockquote);
  CAN(blockhtml);
  CAN(header);
  CAN(hrule);
  CAN(list);
  CAN(listitem);
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
  CAN(strikethrough);
  CAN(entity);
  CAN(normal_text);
  CAN(doc_footer);
  CAN(doc_header);

  return new;
}