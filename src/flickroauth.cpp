#include "flickroauth.h"
#include <QCoreApplication>
#include <QStringList>
#include <QtDebug>
#include <QDesktopServices>

#include "kqoauthrequest.h"
#include "kqoauthrequest_1.h"
#include "kqoauthrequest_xauth.h"
#include "kqoauthmanager.h"
#include "kqoauthglobals.h"
#include "flickroauth_p.h"

#define OAUTH_TOKEN "oauth_token"
#define OAUTH_TOKEN_SECRET "oauth_token_secret"
#define NSID "user_nsid"
#define USERNAME "username"
#define FULLNAME "fullname"


// Private class
FlickrOAuthPrivate::FlickrOAuthPrivate(FlickrOAuth * parent):
    q_ptr(parent),
    m_oauthManager(0),
    m_oauthRequest(0),
    m_oauthSettings("d-pointer","quickflickr"),
    m_key(),
    m_secret(),
    m_authStep(-1)
{    
}


void FlickrOAuthPrivate::onRequestReady(QByteArray response,int id)
{
    Q_Q(FlickrOAuth);    
    qDebug() << Q_FUNC_INFO << " req id: " << id;
    emit q->methodCallDone(QString::fromUtf8(response.data()), id);
}

void FlickrOAuthPrivate::onAuthenticationDone(QByteArray response)
{
    qDebug() << "** " << Q_FUNC_INFO << "**" << m_authStep;
    Q_Q(FlickrOAuth);
    switch(m_authStep){
    case 0:
    {

        if ( response.isEmpty()){
            qWarning() << "Empty response";
            emit q->authenticationError();
            return;
        }

        QMultiMap<QString,QString> tokens = createTokensFromResponse(response);
        m_oauth_token = tokens.value("oauth_token");
        m_oauth_token_secret = tokens.value("oauth_token_secret");
        m_oauth_callback_confirmed = tokens.value("oauth_callback_confirmed");
        QUrl openWebPageUrl("http://www.flickr.com/services/oauth/authorize", QUrl::StrictMode);
        openWebPageUrl.addQueryItem(QString("oauth_token"),m_oauth_token);
        if (!QDesktopServices::openUrl(openWebPageUrl)){
            qWarning() << "Failed to open url: " << openWebPageUrl;
        }

        qDebug() << "Token: " << m_oauth_token << "Secret: " << m_oauth_token_secret << "Confirmed: " << m_oauth_callback_confirmed;
        emit q->verifierRequired();

    }
    break;
    case 1:
    {
        qDebug() << "Received authentication tokens: " << response;        
        QMultiMap<QString, QString> params =  createTokensFromResponse(response);

        QString problem = params.value("oauth_problem");
        if ( !problem.isEmpty() ){
            emit q->verificationFailure();
            qWarning() << "Invalid verifier";
            return;
        }

        if ( params.value(USERNAME).isEmpty() ||
             params.value(NSID).isEmpty() ||
             params.value(OAUTH_TOKEN).isEmpty() ||
             params.value(OAUTH_TOKEN_SECRET).isEmpty()){
            emit q->authenticationError();
            return;
        }

        m_oauthSettings.setValue(USERNAME, params.value(USERNAME) );
        m_oauthSettings.setValue(NSID, params.value(NSID) );
        m_oauthSettings.setValue(FULLNAME, params.value(FULLNAME) );
        m_oauthSettings.setValue(OAUTH_TOKEN, params.value(OAUTH_TOKEN));
        m_oauthSettings.setValue(OAUTH_TOKEN_SECRET, params.value(OAUTH_TOKEN_SECRET));
        m_oauthSettings.sync();


        disconnect(m_oauthManager, SIGNAL(requestReady(QByteArray)),
                    this, SLOT(onAuthenticationDone(QByteArray)));

        qDebug() << "Authentication is done now...";
        emit q->authenticationDone();
        m_authStep = -1;

    }
    break;
    default:
        qWarning() << "Unknown auth step" << m_authStep;
        break;
    }
}

QMultiMap<QString, QString> FlickrOAuthPrivate::createTokensFromResponse(QByteArray reply)
{
    QMultiMap<QString, QString> result;
    QString replyString(QByteArray::fromPercentEncoding(reply));
    qDebug() << "Reply string for split: " << replyString;

    QStringList parameterPairs = replyString.split('&', QString::SkipEmptyParts);
    foreach (const QString &parameterPair, parameterPairs) {
        QStringList parameter = parameterPair.split('=');
        result.insert(parameter.value(0), parameter.value(1));
        qDebug() << "Inserting: " << parameter.value(0) << " Value: " << parameter.value(1);
    }
    return result;
}

QString FlickrOAuthPrivate::token( const QString &name) const
{
    return m_oauthSettings.value(name).toString();
}


void FlickrOAuthPrivate::setVerifier(const QString &verifier)
{

    QString tmpVerifier(verifier);
    tmpVerifier = tmpVerifier.remove('-');
    tmpVerifier = tmpVerifier.remove(' ').trimmed();
    qDebug() << Q_FUNC_INFO << tmpVerifier;
    m_oauthRequest->clearRequest();
    m_oauthRequest->initRequest(KQOAuthRequest::AccessToken, QUrl("http://www.flickr.com/services/oauth/access_token"));
    m_oauthRequest->setConsumerKey(m_key);
    m_oauthRequest->setConsumerSecretKey(m_secret);
    m_oauthRequest->setVerifier(tmpVerifier);
    m_oauthRequest->setToken(m_oauth_token);
    m_oauthRequest->setTokenSecret(m_oauth_token_secret);
    m_authStep = 1;
    m_oauthManager->executeRequest(m_oauthRequest);
}


// Public API
// FlickrOAuth
FlickrOAuth::FlickrOAuth(const QString &key, const QString &secret):
    d_ptr(new FlickrOAuthPrivate(this))
{
    Q_D(FlickrOAuth);
    d->m_oauthRequest = new KQOAuthRequest;
    d->m_oauthManager = new KQOAuthManager(this);
    d->m_key = key;
    d->m_secret = secret;
    //d->m_oauthRequest->setEnableDebugOutput(true);


    connect(d->m_oauthManager, SIGNAL(authorizedRequestReady(QByteArray,int)),
            d, SLOT(onRequestReady(QByteArray,int)), Qt::UniqueConnection);

}

FlickrOAuth::~FlickrOAuth()
{
    Q_D(FlickrOAuth);
    delete d->m_oauthRequest;
    delete d->m_oauthManager;
    delete d_ptr;
}



void FlickrOAuth::authenticate()
{
    Q_D(FlickrOAuth);   
    qDebug() << Q_FUNC_INFO << "Starting to authenticate";
    connect(d->m_oauthManager, SIGNAL(requestReady(QByteArray)),
                d, SLOT(onAuthenticationDone(QByteArray)), Qt::UniqueConnection);

    d->m_authStep = 0;
    d->m_oauthRequest->initRequest(KQOAuthRequest::TemporaryCredentials, QUrl("http://www.flickr.com/services/oauth/request_token"));
    d->m_oauthRequest->setConsumerKey(d->m_key);
    d->m_oauthRequest->setConsumerSecretKey(d->m_secret);
    d->m_oauthRequest->setCallbackUrl(QUrl("oob"));
    d->m_oauthManager->executeRequest(d->m_oauthRequest);
}


bool FlickrOAuth::removeAuthentication()
{
    Q_D(FlickrOAuth);
    if ( !isAuthenticated() ){
        return false;
    }

    d->m_oauthSettings.setValue(OAUTH_TOKEN, "");
    d->m_oauthSettings.setValue(OAUTH_TOKEN_SECRET,"");
    d->m_oauthSettings.setValue(NSID,"");
    d->m_oauthSettings.setValue(USERNAME,"");

    qDebug() << Q_FUNC_INFO << "Authentication removed";
    return !isAuthenticated();
}


bool FlickrOAuth::callMethod(const QString &method, bool useUserId,  int callId, const FlickrParameters &params )
{

    if ( method.isEmpty()){
        qWarning() << "Empty method name. Can't continue...";
        return false;
    }
    qDebug() << Q_FUNC_INFO << method;
    Q_D(FlickrOAuth);
    d->m_oauthRequest->clearRequest();
    d->m_oauthRequest->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl("http://api.flickr.com/services/rest/"));
    d->m_oauthRequest->setTimeout(0);
    d->m_oauthRequest->setConsumerKey(d->m_key);
    d->m_oauthRequest->setConsumerSecretKey(d->m_secret);
    d->m_oauthRequest->setToken(d->m_oauthSettings.value(OAUTH_TOKEN).toString());
    d->m_oauthRequest->setTokenSecret(d->m_oauthSettings.value(OAUTH_TOKEN_SECRET).toString());

     KQOAuthParameters parameters;
    parameters.insert("method", method);

     if (!params.isEmpty()){
         QMapIterator<QString, QString> i(params);
         while (i.hasNext()) {
             i.next();
             parameters.insert(i.key(), i.value());
             qDebug() << "Key: " << i.key() << " Value: " << i.value();
         }
    }


    if ( useUserId ){
        parameters.insert("user_id", d->m_oauthSettings.value(NSID).toString());
    }


    d->m_oauthRequest->setAdditionalParameters(parameters);    
    d->m_oauthManager->executeAuthorizedRequest(d->m_oauthRequest, callId);
    return true;
}

bool FlickrOAuth::isAuthenticated() const
{
    Q_D(const FlickrOAuth);
    QString oauth_token = d->token(OAUTH_TOKEN);
    QString oauth_token_secret = d->token(OAUTH_TOKEN_SECRET);
     QString nsid = d->token(NSID);
    qDebug() << Q_FUNC_INFO << "NSID: "  << nsid << "Token: " << oauth_token << "Secret: " << oauth_token_secret;

    return !(oauth_token.isEmpty() || oauth_token_secret.isEmpty() || nsid.isEmpty());
}

QString FlickrOAuth::nsid() const
{
    Q_D(const FlickrOAuth);
    return d->token(NSID);
}

QString FlickrOAuth::userName() const
{
    Q_D(const FlickrOAuth);
    return d->token(USERNAME);
}

QString FlickrOAuth::fullName() const
{
    Q_D(const FlickrOAuth);
    return d->token(FULLNAME);
}

void FlickrOAuth::setVerifier(const QString verifier)
{
    Q_D(FlickrOAuth);
    d->setVerifier(verifier);
}

