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
    id: flickrText

    property alias text: body.text
    property alias elide: body.elide
    property alias textFormat: body.textFormat
    property alias wrapMode: body.wrapMode
    property color headerColor: settings.textHeaderColor
    property string header
    property int fontPixelSize: settings.mediumFontSize

    height:  body.paintedHeight
    width:  header.paintedWidth+10+body.paintedWidth
    Row{
        spacing: 10
        anchors.fill: parent

        Text {
            id: header
            color:  headerColor
            font.bold: true
            font.pixelSize: fontPixelSize
            text:  flickrText.header + ":"
            visible: flickrText.header != ""
        }

        Text {
            id: body
            color: settings.fontColor
            smooth:  true
            font.pixelSize: fontPixelSize
            width: flickrText.width - header.paintedWidth
            font.bold: true
        }
    }
}
