/**
 * QuickFlickr - Flickr client for mobile devices.
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
import QtQuick 1.1
import com.nokia.meego 1.0

BasePage{
    id: rootFavoritesPage
    property bool loading: false
    property int currentPageIndex: 1
    property int perPage: 24
    property int maxPageIndex: 1
    signal thumbnailClicked( string photoId, url photoUrl, int index )


    // Function to get next photostream page
    function nextFavoritesPage()
    {
        if (loading){
            return;
        }

        if ( favoritesModel.count < perPage ){
            return;
        }

        if (flickrManager.isLiteVersion() && currentPageIndex == 1){
            flickrManager.notifyNotSupported();
            return;
        }

        loading = true;
        //favoritesModel.xml = "";
        ++currentPageIndex;
        flickrManager.getFavorites( perPage, currentPageIndex );
    }

    // Function to get previous photostream page
    function prevFavoritesPage()
    {
        if ( currentPageIndex == 1 || loading){
            return;
        }


        //favoritesModel.xml = "";
        loading = true;
        --currentPageIndex;
        flickrManager.getFavorites(perPage, currentPageIndex );
    }

    FavoritesModel{
        id: favoritesModel
        onStatusChanged:{
            rootFavoritesPage.handleStatusText(favoritesModel, "Favorites");

            if ( status == XmlListModel.Ready && count > 0){
                rootFavoritesPage.maxPageIndex =  utils.lastPageIndex(favoritesModel.xml);
            }
        }
    }


    // Connections to the C++ interface
    Connections{
        target: flickrManager
        onFavoritesUpdated: { favoritesModel.xml = xml; loading = false; }
        onFavoriteRemoved: { flickrManager.getFavorites(24, rootFavoritesPage.currentPageIndex);}
    }

    ThumbnailView{
        anchors.top:    parent.top
        anchors.topMargin: 5
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        model: favoritesModel
        loading: favoritesModel.status != XmlListModel.Ready//parent.loading
        onClicked: parent.thumbnailClicked(photoId, photoUrl, index );
        onLoadNextThumbnails: nextFavoritesPage();
        onLoadPreviousThumbnails: prevFavoritesPage();
    }
}
