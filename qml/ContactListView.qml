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
    id: contactListView
    // Signal for indicating that user has been clicked
    signal clicked(string nsid)
    property bool isModelUpdated: false


    Connections{
        target: flickrManager
        onContactsUpdated: {contactListModel.xml = xml; isModelUpdated = true;}
    }

    ContactListModel{
        id: contactListModel

        onStatusChanged: contactListView.handleStatusText(contactListModel, "Contacts");
    }

    Component{
        id: cdelegate

        AvatarWithTextDelegate{
            source: "http://farm"+iconfarm+".static.flickr.com/"+iconserver+"/buddyicons/"+nsid+".jpg";
            headerText: username
            text:  realname
            animateAppearence: false
            MouseArea{
                anchors.fill: parent
                onClicked: contactListView.clicked( nsid );
            }
        }
    }

    ListView{
        id: contactList
        anchors.fill: parent
        anchors.topMargin: settings.mediumMargin
        anchors.bottomMargin: settings.mediumMargin
        delegate: cdelegate
        model: contactListModel
        cacheBuffer: settings.pageHeight
        clip: true
        spacing: settings.mediumMargin


        ScrollBar{
            scrollArea: parent
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.rightMargin: 5
        }

    }


    Item{
        anchors.fill: contactList
        visible:  contactListModel.xml == ""
         Loading{
             id: loader
             anchors.centerIn: parent
         }
    }
}
