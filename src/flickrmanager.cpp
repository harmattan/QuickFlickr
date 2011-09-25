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
#include "keys.h"

#include <QList>
#include <QDesktopServices>
#include <QMessageBox>
#include <QSettings>
#include <QHash>
#include <QStringListModel>
#include <QMapIterator>
#include <QVariant>
#include <QtDebug>


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
#ifdef LITE
    params.insert("count", "5" );
#else
    params.insert("count", "30" );
#endif
    d->m_qtFlickr->callMethod("flickr.photos.getContactsPublicPhotos", true,  GetContactsPublicPhotos, params);
}

void FlickrManager::getPhotostream(const QString & userId, int page)
{
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
#ifdef LITE
    params.insert("per_page", "5" );
#else
    params.insert("per_page", "30" );
#endif
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
    // Now we are authenticated, let's get some stuff from Flickr
    getLatestContactUploads();
}

void FlickrManager::methodCallDone(const QString & reply, int callId)
{
    switch(callId){
    case GetContactsPublicPhotos:        
        emit contactsUploadsUpdated(reply);
        break;

    case GetContacts:        
        emit contactsUpdated(reply);
        break;

    case GetPhotosOfContact:        
        emit photostreamUpdated(reply);
        break;

    case GetRecentActivity:        
        emit recentActivityUpdated(reply);
        break;

    case GetComments:        
        emit commentsUpdated(reply);
        break;

    case AddComment:        
        emit commentAdded();
        break;

    case AddFavorite:        
        // No specific response
        break;

    case GetFavorites:        
        emit favoritesUpdated(reply);
        break;

    case RemoveFavorite:
        emit favoriteRemoved();
        break;

    case GetUserInfo:        
        emit userInfoUpdated(reply);
        break;

    case GetPhotoInfo:        
        emit photoInfoUpdated(reply);
        break;

    case GetPhotoFavorites:        
        emit photoFavoritesUpdated(reply);
        break;

    case SearchTags:
        emit tagSearchUpdated(reply);
        break;

    case SearchFreeText:
        emit textSearchUpdated(reply);
        break;

    case SearchLocation:
        qDebug() << reply;
        emit locationSearchUpdated(reply);
        break;

    case GetInterestingness:
        emit interestingnessUpdated(reply);
        break;

    default:        
        qWarning() << "Unknown Request!";
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

void FlickrManager::searchTags(const QString & tagsList, int page, bool ownPhotosOnly)
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("tags", tagsList);
    params.insert("tag_mode", "all");
    params.insert("per_page", "20");
    params.insert("page", QString::number(page));
    params.insert("extras", "url_s,owner_name,url_m,url_s,url_z,o_dims,media");
    d->m_qtFlickr->callMethod("flickr.photos.search", ownPhotosOnly, SearchTags,  params );
}

void FlickrManager::searchFreeText( const QString & text, int page, bool ownPhotosOnly)
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("text", text);
    params.insert("per_page", "20");
    params.insert("page", QString::number(page));
    params.insert("extras", "url_s,owner_name,url_m,url_s,url_z,o_dims,media");
    d->m_qtFlickr->callMethod("flickr.photos.search", ownPhotosOnly, SearchFreeText,  params );
}

void FlickrManager::searchLocation(qreal longitude, qreal latitude, int page)
{
    qDebug() << "Lat: " << latitude << "Lon: " << longitude;
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("per_page", "20");
    params.insert("page", QString::number(page));
    params.insert("lon", QString::number(longitude));//"22.28");//
    params.insert("lat", QString::number(latitude));//"60.45");//
    params.insert("min_taken_date","2000-01-01+0:00:00");
    params.insert("radius", "20");
    params.insert("has_geo", "1");
    params.insert("extras", "url_s,owner_name,url_m,url_s,url_z,o_dims,media,geo");
    d->m_qtFlickr->callMethod("flickr.photos.search", false, SearchLocation,  params );
}

void FlickrManager::getInterestingness(int page)
{
    Q_D(FlickrManager);
    FlickrParameters params;
    params.insert("extras", "url_s,owner_name,url_m,url_s,url_z,o_dims,media");
    params.insert("per_page","20");
    params.insert("page", QString::number(page));
    d->m_qtFlickr->callMethod("flickr.interestingness.getList", false, GetInterestingness,  params );

}


bool FlickrManager::isLiteVersion() const
{
#ifdef LITE
    return true;
#endif
    return false;
}

void FlickrManager::notifyNotSupported()
{
    emit featureDisabled();
}



