import QtQuick 1.0
import com.meego 1.0

Item{
    property alias source: buddyIcon.source
    property alias headerText: header.text
    property alias text: text.text
    property bool animateAppearence:  true
    signal clicked
    width: settings.pageWidth * 0.98
    height: (header.paintedHeight + text.paintedHeight) + 3* settings.mediumMargin
    opacity:  0
    Behavior on opacity { PropertyAnimation { duration: 400 } }

    Rectangle{
        id: background
        color: "black"
        border.color: "darkGray"
        border.width: 1
        anchors.fill: parent
        opacity: 0.5
        radius: 15
    }

    Image{
        id: buddyIcon
        anchors.left: background.left
        anchors.leftMargin: settings.largeMargin
        anchors.verticalCenter: background.verticalCenter
        width: 48
        height: 48
        onStatusChanged: {if (status == Image.Ready || status == Image.Error){parent.opacity = 1;}else{parent.opacity = 0;}}
    }

    Text{
        id: header
        color: settings.textHeaderColor
        font.bold: true
        font.pixelSize: settings.largeFontSize
        width: parent.width - buddyIcon.width - settings.largeMargin
        elide:  Text.ElideRight
        anchors.left: buddyIcon.right
        anchors.leftMargin: settings.mediumMargin
        anchors.top: background.top
        anchors.topMargin:  settings.smallMargin
        anchors.right:  background.right
    }
    Label{
        id: text
        color: "white"
        wrapMode: Text.Wrap
        textFormat: Text.RichText
        onLinkActivated: Qt.openUrlExternally(link)
        anchors.left: buddyIcon.right
        anchors.leftMargin:  settings.mediumMargin
        anchors.top: header.bottom
        anchors.topMargin: settings.mediumMargin
        anchors.right: background.right
        anchors.rightMargin: settings.mediumMargin
    }
}
