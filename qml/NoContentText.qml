import QtQuick 1.0

Text{
    font.pixelSize: settings.hugeFontSize * 0.7
    color: "white"
    smooth: true

    Behavior on opacity { NumberAnimation{ duration:900}}
    //onOpacityChanged: console.log("Opacity " + opacity + " Changed for: " + text)
}
