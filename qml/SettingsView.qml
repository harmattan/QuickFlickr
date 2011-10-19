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
    orientationLock: PageOrientation.LockPortrait

    Column{
        anchors.fill: parent
        anchors.margins: settings.mediumMargin
        spacing: settings.mediumMargin

        Text{
            color: "white"
            font.pixelSize: settings.hugeFontSize
            text: "Settings"
            smooth: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        FlickrText{
            id: logInfo            
            smooth: true
            header: "You are logged in as"
            fontPixelSize: settings.largeFontSize
            anchors.horizontalCenter: parent.horizontalCenter
            Connections{
                target: flickrManager
                onProceed: logInfo.text = flickrManager.userName();
            }
        }
        Item{
            height: settings.hugeMargin
            width: settings.pageWidth
        }
        Button{            
            text: "Log out"
            onClicked:  flickrManager.removeAuthentication()
            anchors.horizontalCenter: parent.horizontalCenter
            width: settings.buttonWidth
        }

        Item{
            height: settings.hugeMargin * 3
            width: settings.pageWidth
        }


        Text{
            id: aboutHeader
            color: "white"
            font.pixelSize: settings.hugeFontSize
            text: "About"
            smooth:  true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                color: "white"
                font.pixelSize: settings.mediumFontSize * 1.2
                font.bold: true
                text:  "QuickFlickr for N9"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Item{
                height:  settings.hugeMargin
                width: settings.pageWidth
            }
            Text{
                color: "white"
                font.pixelSize: settings.mediumFontSize
                font.bold: true
                text:  "Marko Mattila"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                color: "white"
                font.pixelSize: settings.mediumFontSize
                text:  "marko.mattila@d-pointer.com"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                color: "white"
                font.pixelSize: settings.mediumFontSize
                text:  "Twitter: @zchydem"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Item{
                height:  settings.hugeMargin
                width: settings.pageWidth
            }
            Text{
                color: "white"
                font.pixelSize: settings.mediumFontSize
                font.bold: true
                text:  "Thanks to"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                color: "white"
                font.pixelSize: settings.mediumFontSize
                text:  "Jan Ekholm / @jan_ekholm"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                color: "white"
                font.pixelSize: settings.mediumFontSize
                text:  "Johan Paul / @kypeli"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                color: "white"
                font.pixelSize: settings.mediumFontSize
                text:  "Marko Saari / @mrksaari"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Item{
            height:  settings.hugeMargin * 1.5
            width: settings.pageWidth
        }
        Image{
            source: "qrc:/gfx/d-pointer-logo.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }

    }
}
