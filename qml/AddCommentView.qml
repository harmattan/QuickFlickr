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

Item{
    id: addCommentView
    // An id for photo to which comment will be added
    property string photoId
    signal commentAdded()
    signal cancelClicked()
    onPhotoIdChanged: clear() // Clear the old crap if photo id changes
    width: settings.pageWidth

    function clear(){
        commentText.text = "";
    }

    function cancel()
    {
        commentText.platformCloseSoftwareInputPanel();
        addCommentView.cancelClicked();
        addCommentView.clear();
    }

    function addComment( text)
    {
        if (photoId == ""){
            console.log("Can't add comment. Photo id is empty");
            return;
        }

        if (text == ""){
            console.log("Can't add comment. Comment string is empty");
            return;
        }

        flickrManager.addComment(photoId, text);
        addCommentView.clear();
        addCommentView.commentAdded();
        commentText.platformCloseSoftwareInputPanel();
    }

    Rectangle {
        id: addCommentBg
        color: "black"
        opacity: 0.8
        anchors.fill: parent        
    }

    Text{
        id: addCommentTitle
        text: "Add Comment:"
        font.pixelSize: settings.largeFontSize
        font.bold: true
        color: settings.fontColor
        anchors.top: addCommentBg.top
        anchors.margins: settings.mediumMargin
        anchors.left: addCommentBg.left
        anchors.right: addCommentBg.right
    }

    TextArea{
        id: commentText
        anchors.top:  addCommentTitle.bottom
        anchors.left:  parent.left
        anchors.right: parent.right
        anchors.margins: settings.mediumMargin
        height:  settings.portrait?parent.height / 2.5: parent.height / 5.8
        wrapMode: TextEdit.Wrap        
        placeholderText: "Write your comment ..."
    }

    Item{
        id: buttonGroup
        anchors.top: commentText.bottom
        anchors.topMargin: settings.largeMargin
        anchors.horizontalCenter: commentText.horizontalCenter

        Button{
            id: cancelButton
            text: "Cancel"
            onClicked: addCommentView.cancel()
            width:  settings.buttonWidth
            anchors.right: addButton.left
            anchors.top:  parent.top
        }
        Button{
            id: addButton
            text: "Add"
            onClicked: addCommentView.addComment(commentText.text)
            width:  settings.buttonWidth
            anchors.top:  parent.top
        }        
    }




}
