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
    width: grid.cellWidth
    height: grid.cellHeight
    property url mediumSizeUrl:""// "http://farm"+farm+".static.flickr.com/"+server+"/"+id+"_"+secret+".jpg"
    FlickrImage{
        id: thumbnailImage
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        showBorder: true
        source:     url_s
        //source: "http://farm"+farm+".static.flickr.com/"+server+"/"+id+"_"+secret+"_t.jpg"
        borderWidth: 3
        width:      settings.gridCellWidth
        height:     settings.gridCellHeight
        fillMode: Image.PreserveAspectCrop
        clip:  true
        showLoader: false
        //transform: Rotation{origin.x: width/2; origin.y: height/2; axis { x: 0; y: 0; z: 1 } angle: Math.random() * 10 * (index % 2?-1:1) }
        smooth: true
        onClicked:{ parent.clicked(photoid, mediumSizeUrl, index); }
    }

    Image{
        anchors.centerIn: parent
        source: "qrc:/gfx/play-small.png"
        opacity: media == "video" && media_status == "ready"?1:0
        smooth: true
        scale: thumbnailImage.imageScale
        Behavior on opacity {NumberAnimation { duration: 400 }}
    }
}

