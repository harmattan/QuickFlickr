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
    id: timelineView
    signal thumbnailClicked( string photoId, url photoUrl, string owner )
    noContentText: "Loading Uploads"
    property int currentItemIndex: 0

    ContactUploadsModel{
        id: timelineModel
        onStatusChanged: {
            timelineView.handleStatusText(timelineModel, "Uploads");            
        }
    }

    Connections{
       target: flickrManager
       onContactsUploadsUpdated: { timelineModel.xml = xml;}
   }


    ListView{
        id: path
        anchors.fill: parent
        delegate: TimelineDelegate{}
        model: timelineModel
        clip: true
        orientation: ListView.Vertical
        snapMode: ListView.SnapOneItem
        cacheBuffer: settings.pageHeight
        currentIndex: timelineView.currentItemIndex
        onCurrentIndexChanged: {timelineView.currentItemIndex = currentIndex;}
        highlightRangeMode: ListView.StrictlyEnforceRange
    }


    Loading{
        id: loader
        anchors.centerIn: parent
        visible:  (timelineModel.status != XmlListModel.Ready && !timelineView.showNoText)
    }

}
