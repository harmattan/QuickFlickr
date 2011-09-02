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
#ifndef FLICKRMANAGER_H
#define FLICKRMANAGER_H

#include <QObject>
#include "flickroauth.h"

class FlickrManagerPrivate;


class FlickrManager : public QObject
{
    Q_OBJECT    

public:
    enum RequestId
    {
        GetContacts,
        GetContactsPublicPhotos,
        GetPhotosOfContact,
        GetRecentActivity,
        GetComments,
        AddComment,
        AddFavorite,
        GetFavorites,
        RemoveFavorite,
        GetUserInfo,
        GetPhotoInfo,
        GetPhotoFavorites,
        RequestCount

    };

    FlickrManager();

    virtual ~ FlickrManager();

    Q_INVOKABLE void activate();

    Q_INVOKABLE void removeAuthentication();
    
    Q_INVOKABLE void authenticate();

    Q_INVOKABLE void getContacts();

    Q_INVOKABLE void getLatestContactUploads();

    Q_INVOKABLE void getPhotostream(const QString & userId, int page);

    Q_INVOKABLE void getUserInfo(const QString & userId);

    Q_INVOKABLE void getRecentActivity();        
        
    Q_INVOKABLE bool isAuthenticated() const;
    
    Q_INVOKABLE void getComments( const QString & photoId );

    Q_INVOKABLE void addComment(const QString & photoId, const QString & commentText );

    Q_INVOKABLE void addFavorite( const QString & photoId );
    
    Q_INVOKABLE void getFavorites( int perPage, int page );
    
    Q_INVOKABLE void removeFavorite( const QString & photoId );
    
    Q_INVOKABLE void getPhotoInfo(const QString & photoId );

    Q_INVOKABLE void getPhotoFavorites(const QString & photoId );

    Q_INVOKABLE QString nsid() const;

    Q_INVOKABLE QString userName() const;

    Q_INVOKABLE void setVerifier(const QString & verifier );

Q_SIGNALS:
    void authenticationRequired();
    void proceed();        
    void contactsUploadsUpdated(const QString & xml);
    void contactsUpdated(const QString & xml);
    void photostreamUpdated( const QString & xml);
    void recentActivityUpdated( const QString & xml);
    void commentsUpdated( const QString & xml);
    void commentAdded();
    void favoritesUpdated( const QString & xml);
    void favoriteRemoved();
    void userInfoUpdated( const QString & xml);
    void photoInfoUpdated( const QString & xml);
    void photoFavoritesUpdated(const QString & xml);
    void verifierRequired();
    void verificationFailure();

private Q_SLOTS:            
    void authenticationDone();
    void methodCallDone(const QString & reply, int callId);
    
private:
    FlickrManagerPrivate * d_ptr;
    Q_DECLARE_PRIVATE( FlickrManager )
};

#endif // FLICKRMANAGER_H






