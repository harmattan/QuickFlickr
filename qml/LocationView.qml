import QtQuick 1.1
import QtMobility.location 1.2

import com.meego 1.0

BasePage {
    id: rootLocationView
    signal itemClicked(int index)
    property int currentPageIndex: 1
    property int lastPageIndex: 1
    property bool loading: false
    property Coordinate currentPosition: positionSource.position.coordinate
    property Coordinate clickedImagePosition: click
    property Coordinate lastPos
    noContentText: "Searching..."

    Coordinate{
        id: click
    }


    onStatusChanged: {
        if ( status == PageStatus.Active){
            positionSource.active = true;
        }else{
            positionSource.active = false;
            //positionSource.loaded = false;
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 5000
        property bool loaded: false

        onPositionChanged: {
            if (position.longitudeValid &&
                position.latitudeValid){

                if (!loaded){
                    flickrManager.searchLocation(position.coordinate.longitude,
                                                 position.coordinate.latitude, 1);
                    loading = true;
                    loaded = true;
                }
            }
        }
    }

    LocationModel{
        id: locationModel
        onStatusChanged:{

            rootLocationView.handleStatusText(locationModel, "Nearby Photos");

            if (status == XmlListModel.Ready){
                lastPageIndex = utils.lastPageIndex(locationModel.xml);
                loading = false;
            }
        }
    }

    Connections{
        target: flickrManager
        onLocationSearchUpdated: { locationModel.xml = xml; }
    }

    Column{
        id: location
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 5

        Label{
            text: "My Coordinates"
            color: "white"
            font.bold: true
        }
        Label{
            text: "Latitude: " +positionSource.position.coordinate.latitude
            color: "white"
        }
        Label{
            text: "Longitude: " +positionSource.position.coordinate.longitude
            color: "white"
        }
    }

    function loadNext()
    {

        if ( currentPageIndex >= lastPageIndex){
            return;
        }

        if ( loading ){
            return;
        }

        //locationModel.xml = "";
        ++currentPageIndex;
        flickrManager.searchLocation(positionSource.position.coordinate.longitude,
                                     positionSource.position.coordinate.latitude, currentPageIndex);
        loading = true;

    }

    function loadPrevious()
    {
        if ( 1 == currentPageIndex){
            return;
        }

        if ( loading ){
            return;
        }

        //locationModel.xml = "";
        --currentPageIndex;
        flickrManager.searchLocation(positionSource.position.coordinate.longitude,
                                     positionSource.position.coordinate.latitude, currentPageIndex);

        loading = true;
    }

    ThumbnailView{
        id: locationImages
        anchors.top: location.bottom
        anchors.topMargin: settings.hugeMargin
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        loading: locationModel.status != XmlListModel.Ready
        model: locationModel
        onClicked: rootLocationView.itemClicked(index);
        onLoadNextThumbnails: rootLocationView.loadNext()
        onLoadPreviousThumbnails: rootLocationView.loadPrevious()

    }

    function showImages()
    {

        var i = 0;
        for (i=0; i < locationModel.count; i++){
            console.debug("Latitude: " + locationModel.get(i).latitude);
            console.debug("Longitude: " + locationModel.get(i).longitude);
            var coord = Qt.createQmlObject("import QtQuick 1.1; import QtMobility.location 1.2;"+
                                           "Coordinate{latitude:"+locationModel.get(i).latitude+";longitude:"+locationModel.get(i).longitude+"}",image1,"");
            image1.coordinate = coord;
            image1.source = locationModel.get(i).url_s;
            image1.visible = true;


            var coord2 = Qt.createQmlObject("import QtQuick 1.1; import QtMobility.location 1.2;"+
                                           "Coordinate{latitude:"+locationModel.get(i+1).latitude+";longitude:"+locationModel.get(i+1).longitude+"}",image2,"");
            image2.coordinate = coord2;
            image2.source = locationModel.get(i+1).url_s;
            image2.visible = true;
            return;
            /*
            var component = Qt.createComponent("MapPhoto.qml");
            if (component.status == Component.Ready){
                var newObject = component.createObject(map);

                newObject.coordinate.latitude = locationModel.get(i).latitude;
                newObject.coordinate.longitude = locationModel.get(i).longitude;
                newObject.coordinate.altitude = 0;
                newObject.source = locationModel.get(i).url_z;
                newObject.visible = true;
                console.log("Url: " + locationModel.get(i).url_z);
            }
            */
        }
    }

}
