import QtQuick 1.0

Item{

    id: polaroid
    property alias source:  image.source
    property alias status:  image.status
    signal clicked()

    Rectangle{
        id: background
        anchors.centerIn: parent
        width:  polaroid.width
        height: polaroid.height
        color: "white"
        smooth: true
    }

    Image{
        id: image
        anchors.fill: background
        anchors.margins: 20
        smooth: true
        fillMode: Image.PreserveAspectCrop
        clip:  true

        MouseArea{
            anchors.fill: parent
            onClicked: polaroid.clicked()
        }
    }

    // Black rectangle for polaroid effect
    Rectangle{
        anchors.fill: image

        gradient: Gradient {
             GradientStop { position: 0.0; color: "black" }
             GradientStop { position: 0.5; color: "darkGray" }
             GradientStop { position: 1.0; color: "black" }
           }
        smooth:  true
        opacity:  1
        visible: opacity > 0
        NumberAnimation on opacity{
            to: 0
            duration: 600
            running: image.status == Image.Ready
        }
    }
}
