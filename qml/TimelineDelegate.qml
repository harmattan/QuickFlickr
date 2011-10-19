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

Item{
    width: settings.pageWidth
    height: settings.pageHeight

    /*
    opacity:  PathView.opacity
    z: PathView.z
    scale:  PathView.scale
    */
    Item{
        id: polaroid
        width: 460
        height: 460 + bottomMargin
        smooth:  true

        property int bottomMargin: settings.hugeFontSize + settings.hugeMargin
        anchors.centerIn: parent

        PolaroidImage{
            id: image
            source: "http://farm"+farm+".static.flickr.com/"+server+"/"+id+"_"+secret+".jpg"
            width:  parent.width
            height: parent.height - polaroid.bottomMargin
            onClicked: timelineView.thumbnailClicked(id, image.source, owner);
            anchors.centerIn:parent
        }


        Label{
            id: author
            anchors.bottom: image.top
            anchors.horizontalCenter: polaroid.horizontalCenter
            anchors.bottomMargin: 10
            width:  settings.pageWidth
            //height: polaroid.bottomMargin
            smooth:  true
            color: "white"
            text:  username
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: settings.hugeFontSize
            font.capitalization: Font.AllLowercase
            opacity: image.status == Image.Ready?1:0//(polaroid.scale > 0.98 && image.status == Image.Ready)? 1:0
            Behavior on opacity { NumberAnimation{ duration: 400}}
            visible:  settings.portrait
        }
    }
}

