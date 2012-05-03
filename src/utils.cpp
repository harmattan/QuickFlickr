#include "utils.h"
#include <QApplication>
#include <QDesktopWidget>
#include <QDateTime>
#include <QtDebug>

Utils * Utils::instance()
{
    static Utils instance;
    return &instance;
}


int Utils::displayWidth() const
{
    return m_displaySize.width();
}

int Utils::displayHeight() const
{
    return m_displaySize.height();
}

QString Utils::formattedTime( qint64 seconds, const QString & format) const
 {
    QDateTime dt = QDateTime::fromTime_t(seconds);
    return dt.toString(format);
 }

QString Utils::formattedElapsedTime(qint64 seconds) const
{

    QDateTime dt = QDateTime::fromTime_t(seconds);
    QDateTime ct = QDateTime::currentDateTime();
    ct.setTimeSpec(Qt::UTC);
    int elapsedDays = dt.daysTo(ct);


    if ( elapsedDays == 0 ){
        QTime t = dt.time();
        int hours = t.hour();
        int minutes = t.minute();
        if ( hours > 1 ){
            return QString("%1 hours ago").arg(hours);
        }
        if (hours == 1){
            return QString("%1 hour ago").arg(hours);
        }
        if (hours < 0){
            return QString("%1 minutes ago").arg(minutes);
        }
    }

    if ( elapsedDays <= 14){
        if (elapsedDays == 1){
            return QString("%1 day ago").arg(elapsedDays);
        }
        return QString("%1 days ago").arg(elapsedDays);
    }

    if ( 14 < elapsedDays && elapsedDays < 30){
        return QString("%1 weeks ago").arg(elapsedDays/7);
    }

    if (elapsedDays >= 30 && elapsedDays < 60){
        return QString("%1 months ago").arg(elapsedDays/30);
    }

    if (elapsedDays >= 60){
        return QString("%1 months ago").arg(elapsedDays/30);
    }

    return QString("%1 days ago").arg(elapsedDays);
}

int Utils::lastPageIndex(const QString & xml)
{
    // This is ugly, but it's damn easy to get just a single value from xml

    QString key("pages=");
    int index = xml.indexOf(key) +1;
    if ( index < 0){
        return -1;
    }

    int startIndex = index + key.length();
    int endIndex = xml.indexOf("\"", startIndex+1);
    QString returnValue = xml.mid(startIndex, endIndex-startIndex);
    return returnValue.toInt();

}

Utils::Utils(QObject *parent) :
    QObject(parent)
{
#if defined(Q_WS_MAEMO_5)
        m_displaySize.setWidth( qApp->desktop()->screenGeometry().size().height());
        m_displaySize.setHeight( qApp->desktop()->screenGeometry().size().width());
        return;
#endif
#if defined(Q_WS_MAC) || defined(Q_WS_X11)
        m_displaySize.setWidth(360);
        m_displaySize.setHeight(640);
#else
    m_displaySize = qApp->desktop()->screenGeometry().size();
#endif
}


