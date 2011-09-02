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

    width:  (appWindow.inPortrait? 480: 854)//deviceProfile.displayWidth()
    height: (appWindow.inPortrait? 854: 480)//deviceProfile.displayHeight()

    property color defaultBackgroundColor: "black"
    property bool portrait: (width < height)
    property int navigationBarHeight: 30
    property int toolBarHeight: (portrait?80:0)
    property int pageHeight: height - toolBarHeight
    property int pageWidth: width

    property int gridCellHeight: (portrait? 120: 170)
    property int gridCellWidth: (portrait? 120: 170)

    property int scrollbarWidth: 8

    //Fonts
    property int tinyFontSize: 14
    property int smallFontSize: 16
    property int mediumFontSize: 20
    property int largeFontSize: 28
    property int hugeFontSize: 68
    property color fontColor: "white"

    // Margins
    property int smallMargin: 2
    property int mediumMargin: 5
    property int largeMargin: 10
    property int hugeMargin: 15

    property color separatorColor: "white"
    property color textHeaderColor: "steelblue"

    property int buttonWidth: 200
    property int loadMoreThreshold:  100
}
