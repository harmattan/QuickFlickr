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
    void networkError();

public Q_SLOTS:
    void setVerifier(const QString verifier);

private:
    FlickrOAuthPrivate *d_ptr;
    Q_DECLARE_PRIVATE(FlickrOAuth)


};

#endif // FLICKROAUTH_H
