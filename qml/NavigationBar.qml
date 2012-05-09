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
    id: navBar        
    property int currentIndex: 0
    signal itemSelected(string id)

    height: 90 //settings.toolBarHeight
    width: settings.pageWidth

    Rectangle{
        anchors.fill: parent
        color: "black"
        //opacity:0.8
    }


    ListModel{
        id: nbmodel
        ListElement {
             name: "Recent Uploads"
             strId: "startup"
         }
         ListElement {
            name: "Recent Activity"
            strId: "activity"
         }
         ListElement {
             name: "Photostream"
             strId: "photostream"
         }
         ListElement {
             name: "Contacts"
             strId: "contacts"
         }
         ListElement {
             name: "Favorites"
             strId: "favorites"
         }
         ListElement {
             name: "Search"
             strId: "search"
         }
         ListElement {
             name: "Where am I?"
             strId: "location"
         }
         ListElement {
             name: "Settings & About"
             strId: "settings"
         }
    }


    Component{
        id: ldelegate


        Text{
            width: settings.pageWidth
            height: menu.height - 4
            text: name
            color: "white"
            font.pixelSize: settings.largeFontSize*2.2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            smooth: true


            MouseArea{
                anchors.fill: parent                
                onClicked: navBar.itemSelected(strId)
            }
        }
    }



    // List view for containing the actual menu items
    Column{
        anchors.fill: parent
        spacing:  10

        ListView{
            id: menu
            delegate: ldelegate
            height: settings.toolBarHeight - 30
            width:  settings.pageWidth
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem
            flickableDirection: Flickable.HorizontalFlick
            //highlightRangeMode: ListView.StrictlyEnforceRange
            currentIndex: navBar.currentIndex
            onCurrentIndexChanged: navBar.currentIndex = currentIndex
            model:  nbmodel
            boundsBehavior:  Flickable.StopAtBounds
        }




        Row{
            anchors.horizontalCenter: menu.horizontalCenter
            Repeater{
                model: menu.model.count
                Image{
                    smooth:  true
                    source: menu.currentIndex == index?"qrc:/gfx/indicator-selected.png":"qrc:/gfx/indicator-not-selected.png"
                    width:  20
                    height: 20
                    fillMode: Image.PreserveAspectFit
                    opacity: 0.7
                }
            }
        }
    }   
    
}
