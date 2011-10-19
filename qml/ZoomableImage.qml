import QtQuick 1.1
import com.nokia.meego 1.0

Item{
    id: rootZoomableImage
    signal clicked()
    signal longPress()
    property int photoHeight
    property int photoWidth
    property alias source:  photo.source
    property alias status:  photo.status


    Flickable {
         id: flickable
         clip: true
         width:  parent.width
         height: parent.height
         contentWidth: imageContainer.width
         contentHeight: imageContainer.height
         onHeightChanged: photo.calculateSize()


         Item {
             id: imageContainer
             width: Math.max(photo.width * photo.scale, flickable.width)
             height: Math.max(photo.height * photo.scale, flickable.height)

             Image {
                 id: photo
                 property real prevScale
                 anchors.centerIn: parent
                 smooth: !flickable.movingVertically
                 sourceSize.width: rootZoomableImage.photoWidth
                 sourceSize.height:rootZoomableImage.photoHeight
                 fillMode: Image.PreserveAspectFit

                 function calculateSize()
                 {
                     scale = Math.min(flickable.width / width, flickable.height / height) * 0.98;
                     pinchArea.minScale = scale;
                     prevScale = Math.min(scale, 1);
                 }

                 onStatusChanged: {
                     if (status == Image.Loading) {
                        indicator.visible = true;
                     } else
                     if (status == Image.Error ){
                         console.log("Error while loading an image ");
                         indicator.visible = false;
                     }
                     else
                     if (status == Image.Ready) {
                         indicator.visible = false;
                         calculateSize();
                     }
                 }

                 onScaleChanged: {

                     if ((width * scale) > flickable.width) {
                         var xoff = (flickable.width / 2 + flickable.contentX) * scale / prevScale;
                         flickable.contentX = xoff - flickable.width / 2;
                     }
                     if ((height * scale) > flickable.height) {
                         var yoff = (flickable.height / 2 + flickable.contentY) * scale / prevScale;
                         flickable.contentY = yoff - flickable.height / 2;
                     }

                     prevScale = scale;

                 }
             }
         }

         PinchArea{
             id: pinchArea
             property real minScale:  1.0
             anchors.fill: parent
             property real lastScale: 1.0
             pinch.target: photo
             pinch.minimumScale: minScale
             pinch.maximumScale: 3.0

             onPinchFinished: flickable.returnToBounds()
         }


         MouseArea {
            id: mousearea
            anchors.fill : parent
            property bool doubleClicked:  false

            Timer{
                id: clickTimer
                interval: 520
                onTriggered: rootZoomableImage.clicked()
                running: false
                repeat:  false
            }

            onDoubleClicked: {
                clickTimer.stop();
                mouse.accepted = true;
                console.log("Double clicked");
                if ( photo.scale > pinchArea.minScale){
                    photo.scale = pinchArea.minScale;
                    flickable.returnToBounds();
                }else{
                    photo.scale = 3.0;
                }
            }

            onClicked: clickTimer.start()//{rootZoomableImage.clicked(); console.log("clicked");}
            //onPressAndHold: rootZoomableImage.longPress();
         }
    }


     Loading{
         id: indicator
         visible: false
         anchors.centerIn: parent
     }
 }


