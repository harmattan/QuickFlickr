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
import com.meego 1.0

BasePage {
    id: photostreamView
    signal thumbnailClicked( string photoId, url photoUrl, int index )
    property int currentPageIndex: 1
    property int lastPageIndex: 1
    property string userid
    property bool loading: true
    //onStatusChanged: { if (status == PageStatus.Deactivating){ clearAll(); }}

    PhotostreamModel{
        id: photostreamModel

        onStatusChanged:{
            photostreamView.handleStatusText(photostreamModel, "Photostream");

            if ( status == XmlListModel.Ready){
                lastPageIndex = utils.lastPageIndex(photostreamModel.xml);
            }
        }
    }

    UserInfoModel{
        id: userInfoModel
    }

    // Connections to the C++ interface
    Connections{
        target: flickrManager
        onPhotostreamUpdated: { photostreamModel.xml = xml; loading = false;}
        onUserInfoUpdated: { userInfoModel.xml = xml}
    }

    function clearAll()
    {        
        photostreamModel.xml = "";
        userInfoModel.xml = "";
        lastPageIndex = 1;
    }

    function clearGrid()
    {
        photostreamModel.xml = "";        
        loading = true;
        lastPageIndex = 1;
    }


    // Function to get next photostream page
    function nextPhotostreamPage()
    {
        if (currentPageIndex == lastPageIndex){
            return;
        }
        if (flickrManager.isLiteVersion() && currentPageIndex == 1){
            flickrManager.notifyNotSupported();
            return;
        }

        clearGrid();
        ++currentPageIndex;
        flickrManager.getPhotostream( userid, currentPageIndex );
    }

    // Function to get previous photostream page
    function prevPhotostreamPage()
    {
        if ( currentPageIndex == 1){
            return;
        }

        clearGrid();
        --currentPageIndex;
        flickrManager.getPhotostream( userid, currentPageIndex );
    }


    // Because we get all the user data also in XML, let's create a view
    // for a single user information
    ListView{
        id:spacer
        height: 110
        width:  parent.width
        interactive: false
        anchors.top: parent.top
        model:  userInfoModel
        delegate:  UserInfoDelegate{}
    }

    // Grid for thumbnails
    ThumbnailView{
        anchors.top:    spacer.bottom
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: parent.bottom
        model: photostreamModel
        loading: parent.loading
        onClicked: parent.thumbnailClicked(photoId, photoUrl, index );
        onLoadNextThumbnails: nextPhotostreamPage();
        onLoadPreviousThumbnails: prevPhotostreamPage();
    }
}
