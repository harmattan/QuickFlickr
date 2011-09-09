/**
 * QuickFlickr - FlickrClient for mobile devices.
 *
 * Author: Marko Mattila (marko.mattila@d-pointer.com)
 *         http://www.d-pointer.com
 *
 *  QuickFlickr is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  QuickFlickr is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with QuickFLickr.  If not, see <http://www.gnu.org/licenses/>.
 */
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
