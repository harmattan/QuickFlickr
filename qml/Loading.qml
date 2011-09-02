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
    id: loading
    width: image.width
    height:  image.height
    Image {
        id: image
        anchors.centerIn: parent
        source: "qrc:/gfx/loading-1.png"
        NumberAnimation on rotation {
            from: 0; to: 360; running: loading.visible == true; loops: Animation.Infinite; duration: 900
        }

        smooth: true
    }
    Image{
        anchors.centerIn: parent
        source: "qrc:/gfx/loading-2.png"
        NumberAnimation on rotation {
            from: 360; to: 0; running: loading.visible == true; loops: Animation.Infinite; duration: 900
        }
        smooth: true
    }

    Image {
        anchors.centerIn: parent
        source: "qrc:/gfx/loading-3.png"
        NumberAnimation on rotation {
            from: 0; to: 360; running: loading.visible == true; loops: Animation.Infinite; duration: 1800
        }

        smooth: true
    }
    Image{
        anchors.centerIn: parent
        source: "qrc:/gfx/loading-4.png"
        NumberAnimation on rotation {
            from: 360; to: 0; running: loading.visible == true; loops: Animation.Infinite; duration: 1800
        }
        smooth: true
    }
}
