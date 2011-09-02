#ifndef FLICKROAUTH_H
#define FLICKROAUTH_H

#include <QObject>
#include <QSettings>
#include <QMultiMap>

typedef QMultiMap<QString, QString> FlickrParameters;
class FlickrOAuthPrivate;
class FlickrOAuth : public QObject
{
    Q_OBJECT
public:
    explicit FlickrOAuth(const QString & key, const QString & secret);
    ~FlickrOAuth();
    void authenticate();
    bool removeAuthentication();
    bool isAuthenticated() const;
    bool callMethod(const QString &method, bool useUserId, int callId, const FlickrParameters &params = FlickrParameters());
    QString nsid() const;
    QString userName() const;
    QString fullName() const;

Q_SIGNALS:
    void verifierRequired();
    void authenticationDone();
    void methodCallDone(const QString & reply, int callId);
    void authenticationError();
    void verificationFailure();

public Q_SLOTS:
    void setVerifier(const QString verifier);

private:
    FlickrOAuthPrivate *d_ptr;
    Q_DECLARE_PRIVATE(FlickrOAuth)


};

#endif // FLICKROAUTH_H
