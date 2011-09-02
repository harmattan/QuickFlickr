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
    id: iconButton
    signal clicked()        
    property bool enabled: true
    property string disabledIconSource
    property string enabledIconSource

    width:60
    height:60

    Image{
        id: icon
        smooth: true
        anchors.fill: parent
        source: iconButton.enabled? enabledIconSource: disabledIconSource
        sourceSize.width: 60
        sourceSize.height: 60
    }


    MouseArea{
        id: mouseArea
        anchors.fill: parent        
        onClicked: { if (iconButton.enabled)iconButton.clicked();}
    }

    states: [
        State {
            name: "pressed"
            when:  iconButton.enabled && mouseArea.pressed
            PropertyChanges {
                target: icon                
                scale: 0.9
            }
        }

    ]

    transitions: Transition { PropertyAnimation{ duration: 100; easing.type: Easing.InElastic; properties: "scale" }}
}
