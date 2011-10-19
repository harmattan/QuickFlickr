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
Page{

    Rectangle{
        anchors.fill: parent
        color:  settings.defaultBackgroundColor
    }

    onStatusChanged: { if( status == PageStatus.Inactive) photoDetailsModel.xml = "";}

    // Update the view if FlickrManager emits signals
    Connections{
        target: flickrManager
        onPhotoInfoUpdated: {photoDetailsModel.xml = xml; }
    }

    PhotoDetailsModel{ id: photoDetailsModel }

    // Image details under the large image
    ListView{
        id: photoDetailsList
        model: photoDetailsModel
        delegate: PhotoDetailsDelegate{}
        width: settings.pageWidth                
    }
}
