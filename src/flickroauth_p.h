#ifndef FLICKROAUTH_P_H
#define FLICKROAUTH_P_H
#include <QObject>
#include <QSettings>
#include <QMultiMap>

class FlickrOAuth;
class KQOAuthManager;
class KQOAuthRequest;
class FlickrOAuthPrivate: public QObject
{
    Q_OBJECT
public:
    FlickrOAuthPrivate(FlickrOAuth * parent);

    QMultiMap<QString, QString> createTokensFromResponse(QByteArray reply) ;
    QString token( const QString &name) const;
    void setVerifier(const QString &verifier);


public Q_SLOTS:    
    void onRequestReady(QByteArray response,int id);
    void onAuthenticationDone(QByteArray response);

public:
    FlickrOAuth * const q_ptr;
    KQOAuthManager *m_oauthManager;
    KQOAuthRequest *m_oauthRequest;
    QSettings m_oauthSettings;
    QString m_key;
    QString m_secret;
    QString m_oauth_token;
    QString m_oauth_token_secret;
    QString m_oauth_callback_confirmed;
    int m_authStep;

    Q_DECLARE_PUBLIC(FlickrOAuth)
};

#endif // FLICKROAUTH_P_H
