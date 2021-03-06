
/******************************************************************************
* MODULE     : text_widget.cpp
* DESCRIPTION: Text widgets for output only
* COPYRIGHT  : (C) 1999  Joris van der Hoeven
*******************************************************************************
* This software falls under the GNU general public license version 3 or later.
* It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
* in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
******************************************************************************/

#include "analyze.hpp"
#include "font.hpp"
#include "window.hpp"
#include "Widkit/basic_widget.hpp"
#include "Widkit/layout.hpp"
#include "dictionary.hpp"

/******************************************************************************
* Text widgets
******************************************************************************/

class text_widget_rep: public basic_widget_rep {
  string  original, s;
  int     style;
  color   col;
  bool    transparent;
  bool    tt;
  metric  ex;
  int     dw, dh;

public:
  text_widget_rep (string s, int style, color col,
		   bool trans, bool tt, int dw, int dh);
  operator tree ();

  void handle_get_size (get_size_event ev);
  void handle_repaint (repaint_event ev);
};

text_widget_rep::text_widget_rep (
  string s2, int st2, color c2,
  bool t2, bool tt2, int dw2, int dh2):
    basic_widget_rep (south_west),
    original (s2), s (s2), style (st2), col (c2),
    transparent (t2), tt (tt2),
    dw (dw2+2*PIXEL), dh (dh2+2*PIXEL)
{
  if (tt) style= style | WIDGET_STYLE_MONOSPACED;
}

text_widget_rep::operator tree () {
  return tree (TUPLE, "text", s);
}

void
text_widget_rep::handle_get_size (get_size_event ev) {
  s= tm_var_encode (original);
  font fn= get_default_styled_font (style);
  fn->var_get_extents (s, ex);
  ev->w = ((ex->x2- ex->x1+ 2)/3)+ 2*dw;
  ev->h = ((fn->y2- fn->y1+ 2)/3)+ 2*dh;
  abs_round (ev->w, ev->h);
}

void
text_widget_rep::handle_repaint (repaint_event ev) { (void) ev;
  renderer ren= ev->win;
  if (!transparent) layout_default (ren, 0, 0, w, h);
  ren->set_pencil (col);
  font fn= get_default_styled_font (style);
  ren->set_shrinking_factor (3);
  fn ->var_draw (ren, s, 3*dw- ex->x1, 3*dh- fn->y1);
  ren->set_shrinking_factor (1);
}

/******************************************************************************
* Interface
******************************************************************************/

wk_widget
text_wk_widget (string s, int style, bool tsp) {
  return tm_new<text_widget_rep> (s, style, black, tsp, false, 3*PIXEL, 0);
}

wk_widget
menu_text_wk_widget (string s, int style, color col, bool tsp, bool tt) {
  return tm_new<text_widget_rep> (s, style, col, tsp, tt, 3*PIXEL, 0);
}
