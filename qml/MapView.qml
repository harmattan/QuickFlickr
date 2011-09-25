import QtQuick 1.1
import QtMobility.location 1.2
import com.meego 1.0

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
    onCurrentItemIndexChanged: console.log("Current Item Index: " + currentItemIndex)
    onOrientationChanged: centerTheView();
    onStatusChanged: {
        if (status == PageStatus.Activating){
            //currentItemIndex = startIndex;
            positionViewAtIndex(currentItemIndex);
            centerTheView();

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
        console.log("Current Item Index: " + currentItemIndex);
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
        }
    }

    Label{
        id: distance
        text: "Distance: " + ((currentPos.distanceTo(map.center)) / 1000.0).toFixed(2)+ " km"
        anchors.top: parent.tools
        anchors.left: parent.left
        anchors.verticalCenter: myLocationCheckBox.verticalCenter
        color: "white"
    }

    CheckBox{
        id: myLocationCheckBox
        anchors.right: parent.right
        anchors.top: parent.top
        text: "<font color=\"white\">My Location</font>"
        onClicked: {showImagePosOnMap(rootMapView.currentPos.latitude, rootMapView.currentPos.longitude)}

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
            console.log("Current item changed: " + currentIndex)
        }

    }



    Flickable{
        id: mapFlickable
        width: rootMapView.width
        height: rootMapView.height - settings.gridCellHeight - settings.mediumMargin - myLocationCheckBox.height
        anchors.top: mapPhotosList.bottom
        anchors.topMargin: settings.mediumMargin
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: settings.mediumMargin

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
            }

        }

    }

}
