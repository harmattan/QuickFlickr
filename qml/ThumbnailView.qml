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


Item{
    signal clicked( string photoId, url photoUrl, int index )
    signal loadNextThumbnails()
    signal loadPreviousThumbnails()
    property alias model: grid.model
    property bool loading: false
    id: thumbnailView
    //clip: true // clip left and right sides
    property int yValue: grid.contentY

    onYValueChanged: checkThreshold( yValue )
    property bool loadNext
    property bool thresholdExceeded:  false
    property int lastYValue:0
    property int thresholdValue:  100


    // TODO: Make this to use grid.contentY directly
    function checkThreshold( yCoordinate ){

        var bottomThreshold =  Math.abs(grid.contentHeight - grid.height) + thresholdValue;

        if (yCoordinate <= lastYValue){
            //console.log("Moving down");
            loadNext = true;
            if (!thresholdExceeded){
                thresholdExceeded = (yCoordinate <= -thresholdValue);
            }

        }else{
            //console.log("Moving up");
            loadNext = false;

            if (!thresholdExceeded){
                thresholdExceeded = (yCoordinate >= bottomThreshold);
            }
        }

        lastYValue = yCoordinate;


    }

    function loadMore()
    {
        if ( loading || !thresholdExceeded ){
            return;
        }

        thresholdExceeded = false;

        if (!loadNext){
            loadPreviousThumbnails();
        }else
        if (grid.atYEnd){
            loadNextThumbnails();
        }
    }


    LoadingIndicatorBox{
        id: topIndicator
        scrollArea: grid
        text:  "Loading previous"
        anchors.top: grid.top
        topLoadingIndicator: true
    }
    LoadingIndicatorBox{
        id: bottomIndicator
        scrollArea: grid
        text:  "Loading next"
        anchors.bottom: grid.bottom
        topLoadingIndicator: false
    }

    GridView{
        id:             grid
        anchors.topMargin: settings.hugeMargin
        anchors.fill: parent
        cellHeight:     (settings.portrait? 120: 170)
        cellWidth:      (settings.portrait? 120: 170)
        delegate:       ThumbnailDelegate{onClicked: thumbnailView.clicked( photoId, photoUrl, index );}
        opacity: loading ?0.2:1
        cacheBuffer: 800
        onMovementEnded: loadMore();
        Behavior on opacity {NumberAnimation{duration: 800}}
    }

    Loading{
        anchors.centerIn: grid
        id: topLoadingIndicator
        visible: parent.loading
    }
}
