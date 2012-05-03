#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QSize>

class Utils : public QObject
{
    Q_OBJECT
public:
    static Utils* instance();
    Q_INVOKABLE int displayWidth() const;
    Q_INVOKABLE int displayHeight() const;
    Q_INVOKABLE QString formattedTime( qint64 seconds, const QString & format) const;
    Q_INVOKABLE QString formattedElapsedTime(qint64 seconds) const;
    Q_INVOKABLE int lastPageIndex(const QString & xml);

protected:
    explicit Utils(QObject *parent = 0);
private:
    QSize m_displaySize;

};

#endif // DEVICEPROFILE_H
