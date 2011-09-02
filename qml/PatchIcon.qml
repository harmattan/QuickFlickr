import QtQuick 1.0

Item{
    property alias enabledIconSource: button.enabledIconSource
    property alias disabledIconSource: button.disabledIconSource
    property alias enabled:  button.enabled
    property alias number:  viewsText.text
    signal clicked()

    width:  100
    height: button.height + viewsText.paintedHeight + settings.mediumMargin

    IconButton{
        id: button
        enabledIconSource: "qrc:///gfx/views.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text{
        id: viewsText
        font.pixelSize: settings.largeFontSize
        anchors.top: button.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        font.bold: true
    }

    MouseArea{
        enabled:  parent.enabled
        anchors.fill: parent
        onClicked: parent.clicked();
    }
}
