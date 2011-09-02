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

Rectangle{
    anchors.fill: parent
    color: "black"
    width:  settings.pageWidth

    FlickrImage{
        id: buddyIcon
        source: "http://farm"+iconfarm+".static.flickr.com/"+iconserver+"/buddyicons/"+nsid+".jpg"
        width: 80
        height: 80
        anchors.top:  parent.top
        anchors.topMargin: settings.mediumMargin
        anchors.right: parent.right
        anchors.rightMargin: settings.mediumMargin
    }

    Label{
        id: userName
        text: username
        color: "white"
        font.pixelSize: settings.largeFontSize * 1.6
        verticalAlignment: Text.AlignTop
        smooth: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: settings.mediumMargin
        anchors.rightMargin: buddyIcon.width + settings.mediumMargin
        anchors.right: parent.right
        width: settings.pageWidth - buddyIcon.width - settings.mediumMargin
        elide: Text.ElideRight
        Component.onCompleted: console.log("xxx"+width)
    }

    FlickrText{
        id: photos
        header:  "Photos"
        text: count
        anchors.top: userName.bottom
        anchors.left: parent.left
        anchors.leftMargin: settings.mediumMargin
        fontPixelSize: settings.smallFontSize
    }

    FlickrText{
        id: pro        
        header: "Pro"
        text: (ispro != 0?"yes":"no")
        anchors.top: photos.bottom
        anchors.topMargin: settings.mediumMargin
        anchors.left: photos.left
        fontPixelSize:  settings.smallFontSize
    }

    FlickrText{
        id: dateTaken        
        header: "First upload"
        text: firstdatetaken // TODO: format this to shorter
        anchors.top:  userName.bottom
        anchors.left: photos.right
        anchors.leftMargin: settings.mediumMargin
        fontPixelSize: settings.smallFontSize
    }
    FlickrText{
        id: location        
        header:  "Location"
        text: (geolocation != ""? geolocation:"unknown")
        anchors.top:  dateTaken.bottom
        anchors.topMargin: settings.mediumMargin
        anchors.left: dateTaken.left
        //anchors.right: dateTaken.right
        fontPixelSize: settings.smallFontSize
    }
}
