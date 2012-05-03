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
    property alias source: image.source
    property alias clip: image.clip
    property alias fillMode: image.fillMode
    property alias smooth: image.smooth
    property alias sourceSize: image.sourceSize    
    property alias imageScale: background.scale
    property bool showBorder: true
    property bool showLoader: true
    property bool showScale: true
    property int  borderWidth: 2
    signal clicked
    signal pressAndHold

    smooth: true
    
    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"
        border.width: showBorder? borderWidth:0
        border.color: showBorder?"white":color
        smooth: true
        scale:  showScale?0:1
        Image{
            id: image            
            anchors.fill: parent
            smooth: true
            anchors.topMargin: background.border.width
            anchors.bottomMargin: background.border.width
            anchors.leftMargin: background.border.width
            anchors.rightMargin: background.border.width
            
        }   

        Loading{            
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            visible: showLoader && (image.status != Image.Ready)
        }        
    }


    MouseArea{
        anchors.fill: parent
        onClicked: parent.clicked();     
        onPressAndHold: parent.pressAndHold();
    }

    states: [
        State {
            name: "Show"; 
            when: image.status == Image.Ready && showScale
            PropertyChanges { target: background; scale: 1 }
        }
    ]    

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "scale"
                easing.type: "OutCubic"
                duration: 500
            }            
        }
    ]

}
