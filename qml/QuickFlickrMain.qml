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

PageStackWindow {
    id: appWindow

    Settings{ id: settings }
    initialPage: splash
    color: "black"
    showStatusBar: false
    showToolBar: (settings.portrait && appWindow.started)
    property bool started:  false

    function showPage(pageid, index)
    {
        if (pageid.status != PageStatus.Inactive){
            return;
        }

        appWindow.pageStack.push(pageid);
        bottomBar.currentIndex = index;
    }


    Connections{
        target: flickrManager
        onProceed: {flickrManager.getLatestContactUploads(); timer.start(); console.log("QML Authentication done")}
        onAuthenticationRequired: appWindow.showPage(authenticationview, 0);
        onFeatureDisabled: { myDialog.open()}
    }


    Timer{
        id: timer
        interval: 4000
        running:  false
        onTriggered: {appWindow.pageStack.push(timelineview); appWindow.started = true;}
    }



    ToolBarLayout {
            id: navigationTools
            visible: appWindow.started
             NavigationBar{
                 id: bottomBar
                 //focus: true

                 onItemSelected: {
                     if ( id == "startup"){
                         appWindow.showPage(timelineview,0);
                     }else
                     if (id == "activity"){
                         if ( !activityview.isModelUpdated ){
                             flickrManager.getRecentActivity();
                         }
                         activityview.defaultState();
                         appWindow.showPage(activityview,1);
                     }else
                     if ( id == "photostream"){
                         if ( appWindow.pageStack.currentPage != photostreamviewer){
                             photostreamview.userid = flickrManager.nsid();
                             flickrManager.getPhotostream( flickrManager.nsid(), 1 );
                             flickrManager.getUserInfo( flickrManager.nsid());
                         }

                         appWindow.showPage(photostreamview,2);

                     }
                     else
                     if ( id == "contacts" ){
                         if ( !contactsview.isModelUpdated ){
                             flickrManager.getContacts();
                         }

                         appWindow.showPage(contactsview,3);
                     }else
                     if ( id == "favorites" ){
                         if (appWindow.pageStack.currentPage != favestreamviewer){
                            flickrManager.getFavorites(24, 1);
                         }
                         appWindow.showPage(favoritesview,4);
                     }else
                     if ( id == "search" ){

                         if (appWindow.pageStack.currentPage != searchview &&
                             appWindow.pageStack.currentPage != searchviewer){
                             searchview.runSearch(false);
                         }

                         appWindow.showPage(searchview,5);
                     }
                     else
                     if ( id == "settings" ){
                        appWindow.showPage(settingsview,6);
                     }


                 }
             }
     }


    Page{
        id:splash
        orientationLock: PageOrientation.LockPortrait
        Image{
            source: "qrc:///gfx/Splash.png"; anchors.centerIn: parent
        }
    }



    AuthenticationView{
        id: authenticationview
    }

    Timelineview{
        id: timelineview
        onThumbnailClicked: {
            photostreamview.clearAll();
            flickrManager.getPhotostream(owner,1);
            flickrManager.getUserInfo( owner )
            photostreamview.userid = owner;
            appWindow.showPage(photostreamview,2);
        }
    }

    RecentActivityView{
        id: activityview
        onThumbnailClicked: {
            //flickrManager.getPhotoInfo(photoId);
            flickrManager.getPhotoFavorites(photoId)
        }
    }

    PhotostreamView{
        id: photostreamview        

        onThumbnailClicked: {
            flickrManager.getPhotoInfo(photoId);
            photostreamviewer.currentItemIndex = index;
            appWindow.showPage(photostreamviewer,2);
        }

        onCurrentPageIndexChanged: {
            if ( photostreamviewer.currentPageIndex != currentPageIndex){
                photostreamviewer.currentPageIndex = currentPageIndex;
            }
        }
    }


    PhotoViewerView{
        id: photostreamviewer

        onCurrentPageIndexChanged: {
            // Update photostreamview's current page index
            if (photostreamview.currentPageIndex != currentPageIndex ){
                photostreamview.currentPageIndex = currentPageIndex;
            }
        }

        onLoadNextImages: {
            ++currentPageIndex;
            startIndex = 0;
            flickrManager.getPhotostream( photostreamview.userid, currentPageIndex);
        }
        onLoadPreviousImages: {
            if ( currentPageIndex > 1){
                --currentPageIndex;
                startIndex = 19;
                flickrManager.getPhotostream( photostreamview.userid, currentPageIndex );
            }
        }

        Connections{
            target: flickrManager
            onPhotostreamUpdated: {photostreamviewer.xml = xml; }
        }
    }

    ContactListView{
        id: contactsview

        onClicked: {
            photostreamview.userid = nsid;
            photostreamview.clearAll();
            flickrManager.getPhotostream( nsid, 1 );
            flickrManager.getUserInfo( nsid )
            appWindow.showPage(photostreamview,2);
        }
    }

    // Favorites view and viewer
    FavoritesView{
        id: favoritesview
        onThumbnailClicked: {
            favestreamviewer.currentItemIndex = index;
            flickrManager.getPhotoInfo(photoId);
            appWindow.showPage(favestreamviewer,4);
        }

        onCurrentPageIndexChanged: {
            if ( favestreamviewer.currentPageIndex != currentPageIndex){
                favestreamviewer.currentPageIndex = currentPageIndex;
            }
        }
    }

    PhotoViewerView{
        id: favestreamviewer

        onCurrentPageIndexChanged: {
            // Update photostreamview's current page index
            if (favoritesview.currentPageIndex != currentPageIndex ){
                favoritesview.currentPageIndex = currentPageIndex;
            }
        }

        onLoadNextImages: {
            ++currentPageIndex;
            startIndex = 0;
            flickrManager.getFavorites( 24, currentPageIndex );
        }

        onLoadPreviousImages: {
            if ( currentPageIndex > 1){
                --currentPageIndex;
                startIndex = 23;
                flickrManager.getFavorites( 24, currentPageIndex );
            }
        }

        Connections{
            target: flickrManager
            onFavoritesUpdated: { favestreamviewer.xml = xml; }
        }
    }
    // End of favorites stuff

    SearchView{
        id: searchview
        onThumbnailClicked: {
            searchviewer.currentItemIndex = index;
            flickrManager.getPhotoInfo(photoId);
            appWindow.showPage(searchviewer,5);
        }

        onCurrentPageIndexChanged: {
            if ( searchviewer.currentPageIndex != currentPageIndex){
                searchviewer.currentPageIndex = currentPageIndex;
            }
        }
    }
    PhotoViewerView{
        id: searchviewer

        onCurrentPageIndexChanged: {
            // Update photostreamview's current page index
            if (searchview.currentPageIndex != currentPageIndex ){
                searchview.currentPageIndex = currentPageIndex;
            }
        }

        onLoadNextImages: {
            ++currentPageIndex;
            startIndex = 0;
            searchview.runSearch(false);
        }

        onLoadPreviousImages: {
            if ( currentPageIndex > 1){
                --currentPageIndex;
                startIndex = 19;
                searchview.runSearch(false);
            }
        }

        Connections{
            target: flickrManager
            onTagSearchUpdated: { searchviewer.xml = xml; }
            onTextSearchUpdated: { searchviewer.xml = xml;}
        }
    }


    SettingsView{
        id: settingsview
    }

    Dialog {
       id: myDialog
       title: Label{
           text: "QuickFlickr Lite for N9";
           color: "white"
           font.pixelSize: settings.largeFontSize
           font.bold: true
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.bottomMargin: settings.hugeMargin
       }

       content: Item{
                width: settings.pageWidth * 0.7
                height: 50
                anchors.centerIn: parent
                Text {
                   id: text
                   anchors.centerIn: parent
                   anchors.margins: settings.hugeMargin
                   color: "white"
                   text: "Upgrade to full version to see more photos!"
                   wrapMode: Text.WordWrap
                   font.pixelSize: settings.mediumFontSize * 1.2
                }
       }

       buttons: ButtonRow {
         style: ButtonStyle { }
           anchors.horizontalCenter: parent.horizontalCenter
           Button {text: "OK"; onClicked: myDialog.accept()}
         }
    }

}
