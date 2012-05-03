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
    id: commentsView    
    width: settings.pageWidth
    property string photoId: ""
    signal close()

    onPhotoIdChanged: clear()

    function clear()
    {
        commentsModel.xml = "";
    }

    Connections{
        target: flickrManager
        onCommentsUpdated: { commentsModel.xml = xml}
        // Make sure that adding a comment also updates this view
        onCommentAdded: { flickrManager.getComments(photoId) }
    }
    
    Component{
        id: commentDelegate
        AvatarWithTextDelegate{
            source: "http://www.flickr.com/buddyicons/"+author+".jpg"
            headerText: authorname
            text: utils.formattedTime(datecreate, "dd MMM yy hh:mm") + "<br>"+comment
            //text: "<i>"+utils.formattedElapsedTime(datecreate, "dd MMM yy hh:mm") + "</u><br>"+comment
        }
    }

    CommentModel{
        id:commentsModel
    }


    Rectangle{
        anchors.fill: parent
        color: settings.defaultBackgroundColor
        opacity:  0.8
    }

    ListView{
        id: commentsList
        delegate: commentDelegate
        model: commentsModel        
        anchors.fill: parent
        clip: true
        spacing: 5
        cacheBuffer: parent.height
        ScrollBar{
            scrollArea: parent
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.rightMargin: 5
        }

        MouseArea{
            anchors.fill: parent
            onClicked: commentsView.close()
        }
    }                

    /*
    Loading{
        anchors.centerIn: commentsList
        visible: commentsModel.xml == ""
    }
    */


}
