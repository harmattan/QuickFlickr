import QtQuick 1.1


Item{
    property int photoId:  photoid
    width:  settings.pageWidth
    height: settings.pageHeight

    function getPhotoInfo()
    {
        flickrManager.getPhotoInfo(photoid);
    }

    ZoomableImage{
        id: zoomableImage
        width: parent.width
        height: parent.height
        source: url_z
        photoWidth: width_z
        photoHeight: height_z
        onClicked: {
            if (detailsLayer.isVisible){
                detailsLayer.state = "";
                //console.log("Hiding details layer");
            }else{
                flickrManager.getPhotoInfo(photoid);
                //console.log("Requesting photo info: " + photoid);
            }

        }
    }

    Image{
        anchors.centerIn: parent
        source: "qrc:/gfx/play-large.png"
        opacity: media == "video" && media_status == "ready"?1:0
        smooth: true
        Behavior on opacity {NumberAnimation { duration: 400 }}
        MouseArea{
            enabled: opacity == 1
            anchors.fill: parent
            onClicked: Qt.openUrlExternally("http://www.flickr.com/photos/"+owner+"/"+photoid)
        }
    }

}
