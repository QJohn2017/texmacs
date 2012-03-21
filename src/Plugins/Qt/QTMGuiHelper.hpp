
/******************************************************************************
* MODULE     : QTMGuiHelper.hpp
* DESCRIPTION: QT Gui helper class. Infrastructure for delayed menu installation 
* COPYRIGHT  : (C) 2008 Massimiliano Gubinelli
*******************************************************************************
* This software falls under the GNU general public license version 3 or later.
* It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
* in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
******************************************************************************/

#ifndef QTMGUIHELPER_HPP
#define QTMGUIHELPER_HPP

#include "qt_gui.hpp"
#include "qt_ui_element.hpp"  // qt_refresh_widget_rep
#include <QObject>
#include <QTranslator>

class QTMGuiHelper : public QObject {
  Q_OBJECT
  qt_gui_rep* gui;

public:
  inline QTMGuiHelper (qt_gui_rep *_gui) : QObject (), gui (_gui) {}

protected:
  bool eventFilter (QObject *obj, QEvent *event);
  
public slots:
  void doUpdate ();
  void doRefresh ();
  void doReadSocketNotification (int socket);  
  void doWriteSocketNotification (int socket);  
  
  void aboutToShowMainMenu ();
  void aboutToHideMainMenu ();
  void doPopWaitingWidgets ();
 
  void emitTmSlotRefresh ();
signals:
  void refresh ();
  void tmSlotRefresh ();   //!< qt_widgets which need to refresh connect here.
};


class QTMTranslator : public QTranslator {
  Q_OBJECT
  
public:
  QTMTranslator(QObject * parent = NULL ) : QTranslator(parent) {};
  virtual QString translate (const char* context, const char* sourceText, 
                             const char* disambiguation = 0 ) const ;  
};


/*! A container widget which redraws the widgets it owns. */
class QTMRefreshWidget : public QWidget {
  Q_OBJECT
  
  string tmwid;
  object curobj;
  widget cur;
  hashmap<object,widget> cache;
  
public:
  QTMRefreshWidget (string _tmwid);
  
  bool recompute ();
  
  public slots:
  void doRefresh ();  
};

#endif // QTMGUIHELPER_HPP
