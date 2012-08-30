
/******************************************************************************
 * MODULE     : QTMGuiHelper.cpp
 * DESCRIPTION: QT Gui helper class. Infrastructure for delayed menu installation 
 * COPYRIGHT  : (C) 2008 Massimiliano Gubinelli
 *******************************************************************************
 * This software falls under the GNU general public license version 3 or later.
 * It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
 * in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
 ******************************************************************************/

#include "QTMGuiHelper.hpp"
#include "qt_tm_widget.hpp"
#include "qt_utilities.hpp"
#include "scheme.hpp"
#include "iterator.hpp"
#include <QFileOpenEvent>

void
QTMGuiHelper::doUpdate () {
    //  cout << "UPDATE " << texmacs_time () << LF;
  gui->update();
}

void
QTMGuiHelper::doRefresh () {
  emit refresh();
}

bool
QTMGuiHelper::eventFilter (QObject *obj, QEvent *event) {
  if (event->type() == QEvent::FileOpen) {
    QFileOpenEvent *openEvent = static_cast<QFileOpenEvent *>(event);
    const char *s = openEvent->file().toAscii().constData();
      //qDebug ("File Open Event %s", s);
    call ("load-buffer", object (url_system (s)), eval (":new-window"));
    return true;
  }
  else {
      // standard event processing
    return QObject::eventFilter(obj, event);
  }
}

void
QTMGuiHelper::doWriteSocketNotification (int socket) {
  if (DEBUG_QT) 
    cout << "WRITE SOCKET NOTIFICATION " << socket << " "
    << texmacs_time () << LF;
  iterator<socket_notifier> it = iterate (gui->write_notifiers);
  while (it->busy ()) {
    socket_notifier sn= it->next ();
    if (sn->fd == socket) {
        //sn->notify();
      the_gui->process_socket_notification (sn);
      the_gui->enable_notifier (sn, false);
    }
  }
}

void
QTMGuiHelper::doReadSocketNotification (int socket) {
  if (DEBUG_QT) 
    cout << "READ SOCKET NOTIFICATION " << socket << " "
    << texmacs_time () << LF;
  iterator<socket_notifier> it = iterate (gui->read_notifiers);
  while (it->busy ()) {
    socket_notifier sn= it->next ();
    if (sn->fd == socket) {
        //sn->notify();
      the_gui->process_socket_notification (sn);
      the_gui->enable_notifier (sn, false);
    }
  }
}

void
QTMGuiHelper::aboutToShowMainMenu() {
    //cout << "Show :" << menu_count << LF;
  menu_count++;
}

void 
QTMGuiHelper::aboutToHideMainMenu() {
  menu_count--;
    //cout << "Hide :" << menu_count << " " << N(waiting_widgets) <<  LF;
  if (menu_count <= 0) {
    menu_count = 0;
    QTimer::singleShot (0, the_gui->gui_helper, SLOT (doPopWaitingWidgets ()));
  }
}

void 
QTMGuiHelper::doPopWaitingWidgets() {
  if (!is_nil(waiting_widgets)) {
    if (DEBUG_QT)
      cout << "Installing postponed menu" << LF;
    waiting_widgets->item->install_main_menu();
    waiting_widgets = waiting_widgets->next;
  }
}

void
QTMGuiHelper::emitTmSlotRefresh () {
  emit tmSlotRefresh();
}


/******************************************************************************
 * QTMRefreshWidget
 ******************************************************************************/

widget make_menu_widget (object wid);

QTMRefreshWidget::QTMRefreshWidget (string _tmwid)
: QWidget (), tmwid (_tmwid), curobj (false), cur (), cache (widget ()) 
{   
  QObject::connect(the_gui->gui_helper, SIGNAL(tmSlotRefresh()), 
                   this, SLOT(doRefresh()));
  doRefresh();
}

bool
QTMRefreshWidget::recompute () {
  string s = "'(vertical (link " * tmwid * "))";
  eval ("(lazy-initialize-force)");
  object xwid = call ("menu-expand", eval (s));

  if (cache->contains (xwid)) {
    if (curobj == xwid) return false;
    curobj = xwid;
    cur    = cache [xwid];
    return true;
  } else {
    curobj = xwid;
    object uwid = eval (s);
    cur = make_menu_widget (uwid);
    cache (xwid) = cur;
    return true;
  }
}

void 
QTMRefreshWidget::doRefresh() {
  if (recompute()) {
    if (layout()) {
      QLayoutItem* item;
      while ((item = layout()->takeAt(0)) != 0) {		
        if (item->widget()) {
          layout()->removeWidget(item->widget());
          delete item->widget();
        }	
        delete item;
      }
      delete layout();
    }
    setLayout(concrete(cur)->as_qlayoutitem()->layout());

      // Tell the window to fix its size to the new one if we had it fixed to
      // begin with (this is indicated by minimum and maximum sizes set to 
      // values other than the default)
    if (window()->minimumSize() != QSize(0,0) && 
        window()->maximumSize() != QSize(QWIDGETSIZE_MAX, QWIDGETSIZE_MAX))
      window()->setFixedSize(window()->sizeHint());  
  }
}


/******************************************************************************
 * QTMComboBox
 ******************************************************************************/

QTMComboBox::QTMComboBox (QWidget* parent) : QComboBox (parent) {
    ///// Obtain the minimum vertical size
  QComboBox cb;
  cb.setSizeAdjustPolicy(AdjustToContents);
  cb.addItem("");
  minSize = cb.sizeHint();  // we'll just keep the height
  
    ///// Add width of the arrow button
  QStyleOptionComboBox opt;
  opt.initFrom(&cb);
  opt.activeSubControls = QStyle::SC_ComboBoxArrow;
  QRect r = style()->subControlRect (QStyle::CC_ComboBox, &opt,
                                     QStyle::SC_ComboBoxArrow, &cb);
  minSize.setWidth(r.width());
}

/*! Add items and fix the ComboBox size using texmacs length units.
 
 Relative sizes are set based on the minimum bounding box in which any item of
 the list fits. Absolute sizes are set independently of the size of items in 
 the list.
 
 The QComboBox' minimum height is the original minimumSizeHint().
 */
void
QTMComboBox::addItemsAndResize (const QStringList& texts, string ww, string hh) {
  QComboBox::addItems(texts);

    ///// Calculate the minimal contents size:
  calcSize = QApplication::globalStrut ();
  const QFontMetrics& fm = fontMetrics ();
  
  for (int i = 0; i < count(); ++i) {
    QRect br = fm.boundingRect(itemText(i));
    calcSize.setWidth (qMax (calcSize.width(), br.width()));
    calcSize.setHeight (qMax (calcSize.height(), br.height()));
  }
  calcSize = qt_decode_length (ww, hh, calcSize, fm);
  
    ///// Add minimum constraints and fix size
  calcSize.setHeight (qMax (calcSize.height(), minSize.height()));
  calcSize.rwidth() += minSize.width();
  
  setMinimumSize (calcSize);
  setMaximumSize (calcSize);
}
