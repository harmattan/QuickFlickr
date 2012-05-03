import QtQuick 1.1
import QtMobility.location 1.2
import com.nokia.meego 1.0

BasePage{
    id: rootMapView
    property int currentItemIndex: -1
    property int startIndex: -1
    property url source
    property string title
    property string owner
    property bool orientation: settings.portrait;

    property Coordinate currentPos
    property Coordinate mapCenter: centerLocation
    Coordinate{ id: centerLocation; }    
    onOrientationChanged: centerTheView();



    onStatusChanged: {
        if (status == PageStatus.Activating){
            //currentItemIndex = startIndex;
            positionViewAtIndex(currentItemIndex);
            centerTheView();
        }else{
            flipable.flipped = false;
        }
    }

    function centerTheView()
    {        
        mapFlickable.contentX = map.size.width / 3
        mapFlickable.contentY = map.size.height / 3
    }

    function showImagePosOnMap(latitude, longitude)
    {
        console.log("Lat: " + latitude + " Lon: " + longitude);
        centerLocation.latitude = latitude;
        centerLocation.longitude = longitude;
        centerTheView();
    }

    function positionViewAtIndex(index)
    {
        //console.log("Current Item Index: " + currentItemIndex);
        mapPhotosList.positionViewAtIndex(index, ListView.Beginning);
        currentItemIndex = index;
        mapPhotosList.currentIndex = index;
    }

    LocationModel{
        id: locationModel
        onStatusChanged:{

            if (status == XmlListModel.Ready){
                if ( locationModel.xml.length === 0){
                    return;
                }

                if (startIndex != -1){
                    positionViewAtIndex(startIndex);
                    startIndex = -1;
                }
            }
        }
    }

    Connections{
        target: flickrManager
        onLocationSearchUpdated: { locationModel.xml = xml;  }
    }


    Component{
        id: mapPhoto
        FlickrImage{
            id: thumbnail
            source: url_s
            width: settings.gridCellWidth
            height: settings.gridCellHeight
            onClicked: {mapPhotosList.currentIndex = index}
            scale: mapPhotosList.currentIndex == index? 1: 0.95
            fillMode: Image.PreserveAspectCrop
            clip: true
        }
    }

    Label{
        id: distance
        text: "Distance: " + ((currentPos.distanceTo(map.center)) / 1000.0).toFixed(2)+ " km"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.verticalCenter: myLocationCheckBox.verticalCenter
        color: "white"
    }

    CheckBox{
        id: myLocationCheckBox
        anchors.right: parent.right
        anchors.top: parent.top
        text: "<font color=\"white\">My Location</font>"
        onClicked: {showImagePosOnMap(rootMapView.currentPos.latitude, rootMapView.currentPos.longitude); flipable.flipped = false}

    }

    ListView{
        id: mapPhotosList
        anchors.left: parent.left
        anchors.top: myLocationCheckBox.bottom
        anchors.topMargin: settings.mediumMargin
        anchors.right: parent.right
        height: settings.gridCellHeight
        orientation: ListView.Horizontal
        model: locationModel
        delegate: mapPhoto
        currentIndex: rootMapView.currentItemIndex
        onFlickStarted: myLocationCheckBox.checked = false
        highlightFollowsCurrentItem: true
        z: 10
        onCurrentIndexChanged: {
            rootMapView.currentItemIndex = currentIndex;
            rootMapView.showImagePosOnMap(locationModel.get(currentIndex).latitude,locationModel.get(currentIndex).longitude)
            largeImage.source = locationModel.get(currentIndex).url_m;
            console.log("Current item changed: " + currentIndex)
        }

    }



    Flipable{
        id: flipable
        property bool flipped: false

        width: rootMapView.width
        height: rootMapView.height - settings.gridCellHeight - settings.mediumMargin - myLocationCheckBox.height

        anchors.top: mapPhotosList.bottom
        anchors.topMargin: settings.mediumMargin
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: settings.mediumMargin

        transform: Rotation {
                id: rotation
                origin.x: flipable.width/2
                origin.y: flipable.height/2
                axis.x: 0;
                axis.y: 1;
                axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            }

        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: 180 }
            when: flipable.flipped
        }

        transitions: Transition {
            NumberAnimation { target: rotation; property: "angle"; duration: 400 }
        }

        back: FlickrImage{
            id: largeImage
           width: mapFlickable.width
           height: mapFlickable.height
           smooth: true
           fillMode: Image.PreserveAspectFit
           showLoader: true
           showBorder: false
           showScale: false
           onClicked: flipable.flipped = !flipable.flipped
        }

        front: Flickable{
            id: mapFlickable
            width: rootMapView.width
            height: (rootMapView.height - settings.gridCellHeight - settings.mediumMargin - myLocationCheckBox.height)*0.95
            contentHeight: map.size.height
            contentWidth: map.size.width
            contentX: map.size.width / 3
            contentY: map.size.height / 3
            clip: true

            Map{
                id: map
                size.width: rootMapView.width * 3
                size.height: (rootMapView.height - settings.gridCellHeight - myLocationCheckBox.height) * 3
                plugin : Plugin {name : "nokia"}
                zoomLevel: 15
                center: rootMapView.mapCenter

                MapImage{
                    id: myPosition
                    source: "qrc:///gfx/map_pin.png"
                    coordinate: rootMapView.mapCenter
                    offset.y: -58
                }

            }

            MouseArea{
                anchors.fill: parent
                onClicked: flipable.flipped = !flipable.flipped
            }
        }
    }

}
