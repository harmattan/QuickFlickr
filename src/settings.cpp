#include "settings.h"

Settings::Settings(QObject *parent) :
    QObject(parent),
    m_settings("d-pointer","quickflickr")
{
}


void Settings::setValue(const QString &key, const QVariant &value)
{
    return m_settings.setValue(key, value);
}

QString Settings::stringValue(const QString &key, const QString &defaultValue) const
{
    return m_settings.value(key,defaultValue).toString();
}

bool Settings::boolValue(const QString &key, bool defaultValue) const
{
    return m_settings.value(key,defaultValue).toBool();
}

void Settings::save()
{
    //m_settings.sync();
}
