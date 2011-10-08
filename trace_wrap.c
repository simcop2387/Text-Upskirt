#include "markdown.h"
#include "html.h"
#include "buffer.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

void trace_blockcode(struct buf *ob, struct buf *text, struct buf *text2, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "blockcode" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT : %.*s\n", text->size - 1, text->data);
    printf("  INPUT2: %.*s\n", text2->size - 1, text2->data);
    realrend->blockcode(ob, text, text2, realopq);
}

void trace_blockquote(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "blockquote" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    realrend->blockquote(ob, text, realopq);
}

void trace_blockhtml(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "blockhtml" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    realrend->blockhtml(ob, text, realopq);
}

void trace_header(struct buf *ob, struct buf *text, int numb, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "header" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT : %.*s\n", text->size - 1, text->data);
    printf("  NUMBER: %d\n", numb);
    realrend->header(ob, text, numb, realopq);
}

void trace_hrule(struct buf *ob, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "hrule" " :: %08X -> %08X\n", opaque, realopq);
    realrend->hrule(ob, realopq);
}

void trace_list(struct buf *ob, struct buf *text, int numb, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "list" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT : %.*s\n", text->size - 1, text->data);
    printf("  NUMBER: %d\n", numb);
    realrend->list(ob, text, numb, realopq);
}

void trace_listitem(struct buf *ob, struct buf *text, int numb, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "listitem" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT : %.*s\n", text->size - 1, text->data);
    printf("  NUMBER: %d\n", numb);
    realrend->listitem(ob, text, numb, realopq);
}

void trace_paragraph(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "paragraph" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    realrend->paragraph(ob, text, realopq);
}

void trace_table(struct buf *ob, struct buf *text, struct buf *text2, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "table" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT : %.*s\n", text->size - 1, text->data);
    printf("  INPUT2: %.*s\n", text2->size - 1, text2->data);
    realrend->table(ob, text, text2, realopq);
}

void trace_table_cell(struct buf *ob, struct buf *text, int numb, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "table_cell" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT : %.*s\n", text->size - 1, text->data);
    printf("  NUMBER: %d\n", numb);
    realrend->table_cell(ob, text, numb, realopq);
}

void trace_table_row(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "table_row" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    realrend->table_row(ob, text, realopq);
}

int trace_autolink(struct buf *ob, struct buf *text, int numb, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "autolink" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    printf("  INPUT : %.*s\n", text->size - 1, text->data);
    printf("  NUMBER: %d\n", numb);
    ret = realrend->autolink(ob, text, numb, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

int trace_codespan(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "codespan" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    ret = realrend->codespan(ob, text, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

int trace_double_emphasis(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "double_emphasis" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    ret = realrend->double_emphasis(ob, text, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

int trace_emphasis(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "emphasis" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    ret = realrend->emphasis(ob, text, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

int trace_image(struct buf *ob, struct buf *text, struct buf *text2, struct buf *text3, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "image" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    printf("  INPUT : %.*s\n", text->size - 1, text->data);
    printf("  INPUT2: %.*s\n", text2->size - 1, text2->data);
    printf("  INPUT3: %.*s\n", text3->size - 1, text3->data);
    ret = realrend->image(ob, text, text2, text3, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

int trace_linebreak(struct buf *ob, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "linebreak" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    ret = realrend->linebreak(ob, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

int trace_link(struct buf *ob, struct buf *text, struct buf *text2, struct buf *text3, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "link" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    printf("  INPUT : %.*s\n", text->size - 1, text->data);
    printf("  INPUT2: %.*s\n", text2->size - 1, text2->data);
    printf("  INPUT3: %.*s\n", text3->size - 1, text3->data);
    ret = realrend->link(ob, text, text2, text3, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

int trace_raw_html_tag(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "raw_html_tag" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    ret = realrend->raw_html_tag(ob, text, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

int trace_triple_emphasis(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "triple_emphasis" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    ret = realrend->triple_emphasis(ob, text, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

int trace_strikethrough(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "strikethrough" " :: %08X -> %08X\n", opaque, realopq);
    int             ret;
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    ret = realrend->strikethrough(ob, text, realopq);
    printf("  RETURN: %d\n", ret);
    return ret;
}

void trace_entity(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "entity" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    realrend->entity(ob, text, realopq);
}

void trace_normal_text(struct buf *ob, struct buf *text, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "normal_text" " :: %08X -> %08X\n", opaque, realopq);
    printf("  INPUT: %.*s\n", text->size - 1, text->data);
    realrend->normal_text(ob, text, realopq);
}

void trace_doc_header(struct buf *ob, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "doc_header" " :: %08X -> %08X\n", opaque, realopq);
    realrend->doc_header(ob, realopq);
}

void trace_doc_footer(struct buf *ob, void *opaque) {
    struct mkd_renderer *realrend = (struct mkd_renderer *) opaque;
    void           *realopq = realrend->opaque;
    printf(">>" "doc_footer" " :: %08X -> %08X\n", opaque, realopq);
    realrend->doc_footer(ob, realopq);
}

struct mkd_renderer *trace_wrap(struct mkd_renderer *orig) {
    struct mkd_renderer *new = malloc(sizeof(struct mkd_renderer));
    new->opaque = orig;

    printf("WRAPPING %08X\n", orig);

    if (orig->blockcode) {
      new->blockcode = trace_blockcode;
    };
    if (orig->blockquote) {
      new->blockquote = trace_blockquote;
    };
    if (orig->blockhtml) {
      new->blockhtml = trace_blockhtml;
    };
    if (orig->header) {
      new->header = trace_header;
    };
    if (orig->hrule) {
      new->hrule = trace_hrule;
    };
    if (orig->list) {
      new->list = trace_list;
    };
    if (orig->listitem) {
      new->listitem = trace_listitem;
    };
    if (orig->table) {
      new->table = trace_table;
    };
    if (orig->table_row) {
      new->table_row = trace_table_row;
    };
    if (orig->table_cell) {
      new->table_cell = trace_table_cell;
    };
    if (orig->autolink) {
      new->autolink = trace_autolink;
    };
    if (orig->codespan) {
      new->codespan = trace_codespan;
    };
    if (orig->double_emphasis) {
      new->double_emphasis = trace_double_emphasis;
    };
    if (orig->emphasis) {
      new->emphasis = trace_emphasis;
    };
    if (orig->image) {
      new->image = trace_image;
    };
    if (orig->linebreak) {
      new->linebreak = trace_linebreak;
    };
    if (orig->link) {
      new->link = trace_link;
    };
    if (orig->raw_html_tag) {
      new->raw_html_tag = trace_raw_html_tag;
    };
    if (orig->strikethrough) {
      new->strikethrough = trace_strikethrough;
    };
    if (orig->entity) {
      new->entity = trace_entity;
    };
    if (orig->normal_text) {
      new->normal_text = trace_normal_text;
    };
    if (orig->doc_footer) {
      new->doc_footer = trace_doc_footer;
    };
    if (orig->doc_header) {
      new->doc_header = trace_doc_header;
    };

    return new;
}
