#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = 0);

    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QString stringValue(const QString &key, const QString & defaultValue) const;
    Q_INVOKABLE bool boolValue(const QString &key, bool defaultValue) const;
    Q_INVOKABLE void save();

private:
    QSettings m_settings;
};

#endif // SETTINGS_H
