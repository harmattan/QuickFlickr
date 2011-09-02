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
#include "flickrmanager.h"


#include <QList>
#include <QDesktopServices>
#include <QMessageBox>
#include <QSettings>
#include <QHash>
#include <QStringListModel>
#include <QMapIterator>
#include <QVariant>
#include <QtDebug>

#define KEY "b4988020794fcf538ef1bd0e333ee5b6"
#define SECRET "cbd1ed5706d20a91"

class FlickrManagerPrivate{
public:
    FlickrManagerPrivate():
        m_qtFlickr(0)
    {            
    }


    FlickrOAuth * m_qtFlickr;
    QHash<int, FlickrManager::RequestId> m_requestId;    

};

FlickrManager::FlickrManager():
        d_ptr( new FlickrManagerPrivate )
{
    setObjectName("FlickrManager");        
}


FlickrManager:: ~ FlickrManager()
{
    delete d_ptr;
    d_ptr = 0;
}


void FlickrManager::activate()
{
    Q_D(FlickrManager);
    d->m_qtFlickr = new FlickrOAuth(KEY, SECRET);

    connect(d->m_qtFlickr, SIGNAL(methodCallDone(QString,int)), this, SLOT(methodCallDone(QString,int)));
    connect(d->m_qtFlickr, SIGNAL(authenticationDone()),this,SIGNAL(proceed()));
    connect(d->m_qtFlickr, SIGNAL(verifierRequired()),this, SIGNAL(verifierRequired()));
    connect(d->m_qtFlickr, SIGNAL(verificationFailure()),this, SIGNAL(verificationFailure()));


    if(d->m_qtFlickr->isAuthenticated()){        
        emit proceed();        
    }else{               
        emit authenticationRequired();
    }
    
}

void FlickrManager::removeAuthentication()
{
    Q_D(FlickrManager);
    d->m_qtFlickr->removeAuthentication();    
    emit authenticationRequired();
}

void FlickrManager::authenticate()
{    
    Q_D(FlickrManager);
    d->m_qtFlickr->authenticate();
}

void FlickrManager::getContacts()
{
    Q_D(FlickrManager);
    FlickrParameters params;
    d->m_qtFlickr->callMethod("flickr.contacts.getList", true,  GetContacts, params);
}


void FlickrManager::getLatestContactUploads()
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("extras", "geo, tags, machine_tags, o_dims, views");
    params.insert("single_photo", "true");
    params.insert("count", "30" );
    d->m_qtFlickr->callMethod("flickr.photos.getContactsPublicPhotos", true,  GetContactsPublicPhotos, params);
}

void FlickrManager::getPhotostream(const QString & userId, int page)
{
    // Clear the old stuff    
    Q_D(FlickrManager);    
    FlickrParameters params;
    params.insert("extras", "owner_name,url_m,url_s,url_z,o_dims,media" );
    params.insert("per_page","20");
    params.insert("page", QString::number(page) );
    params.insert("user_id", userId);    
    d->m_qtFlickr->callMethod("flickr.people.getPhotos", false, GetPhotosOfContact, params);       
}

void FlickrManager::getUserInfo( const QString & userId )
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("user_id", userId);
    d->m_qtFlickr->callMethod("flickr.people.getInfo", false, GetUserInfo, params);
}

void FlickrManager::getRecentActivity()
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("timeframe","200d");
    params.insert("per_page", "30" );
    d->m_qtFlickr->callMethod("flickr.activity.userPhotos", true, GetRecentActivity, params );
}



void FlickrManager::getComments(const QString & photoId)
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("photo_id", photoId);
    d->m_qtFlickr->callMethod("flickr.photos.comments.getList", false, GetComments,  params );
}
    
void FlickrManager::addComment(const QString & photoId, const QString & commentText )
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("photo_id", photoId);
    params.insert("comment_text", commentText);
    d->m_qtFlickr->callMethod("flickr.photos.comments.addComment", false, AddComment,  params );
}

void FlickrManager::addFavorite( const QString & photoId )
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("photo_id", photoId);
    d->m_qtFlickr->callMethod("flickr.favorites.add", false, AddFavorite,  params );
}


void FlickrManager::getFavorites(int perPage, int page)
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("extras", "url_s,owner_name,url_m,url_s,url_z,o_dims,media");
    params.insert("per_page",QString::number(perPage));
    params.insert("page", QString::number(page));
    d->m_qtFlickr->callMethod("flickr.favorites.getList", false, GetFavorites,  params );
}

void FlickrManager::removeFavorite( const QString & photoId )
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("photo_id", photoId);
    d->m_qtFlickr->callMethod("flickr.favorites.remove", false, RemoveFavorite,  params );
}


void FlickrManager::getPhotoInfo(const QString & photoId )
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("photo_id", photoId);
    d->m_qtFlickr->callMethod("flickr.photos.getInfo", false, GetPhotoInfo,  params );
}

void FlickrManager::getPhotoFavorites(const QString & photoId )
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("photo_id", photoId);
    d->m_qtFlickr->callMethod("flickr.photos.getFavorites", false, GetPhotoFavorites,  params );
}

QString FlickrManager::nsid() const
{
    Q_D(const FlickrManager);
    return d->m_qtFlickr->nsid();
}

QString FlickrManager::userName() const
{
    Q_D(const FlickrManager);
    return d->m_qtFlickr->userName();
}


void FlickrManager::authenticationDone()
{
    qDebug() <<  Q_FUNC_INFO << "Authetication Done";
    // Now we are authenticated, let's get some stuff from Flickr
    getLatestContactUploads();
}

void FlickrManager::methodCallDone(const QString & reply, int callId)
{
    switch(callId){
    case GetContactsPublicPhotos:
        //qDebug() << reply;
        emit contactsUploadsUpdated(reply);
        break;

    case GetContacts:
        //qDebug() << reply;
        emit contactsUpdated(reply);
        break;

    case GetPhotosOfContact:
        //qDebug() << reply;
        emit photostreamUpdated(reply);
        break;

    case GetRecentActivity:
        //qDebug() << reply;
        emit recentActivityUpdated(reply);
        break;

    case GetComments:
        //qDebug() << reply;
        emit commentsUpdated(reply);
        break;

    case AddComment:
        Q_UNUSED(reply);
        emit commentAdded();
        break;

    case AddFavorite:
        Q_UNUSED(reply);
        // No specific response
        break;

    case GetFavorites:
        qDebug() << reply;
        emit favoritesUpdated(reply);
        break;

    case RemoveFavorite:
        emit favoriteRemoved();
        break;

    case GetUserInfo:
        //qDebug()<< reply;
        emit userInfoUpdated(reply);
        break;
    case GetPhotoInfo:
        //qDebug()<< xmlData;
        emit photoInfoUpdated(reply);
        break;

    case GetPhotoFavorites:
        //qDebug() << reply;
        emit photoFavoritesUpdated(reply);
        break;

    default:
        {
                qWarning() << "Unknown Request!";

        }
        break;
    }

}


bool FlickrManager::isAuthenticated() const
{
    Q_D(const FlickrManager);
    return d->m_qtFlickr->isAuthenticated();
}


void FlickrManager::setVerifier(const QString & verifier )
{
    Q_D(FlickrManager);
    d->m_qtFlickr->setVerifier(verifier);
}









