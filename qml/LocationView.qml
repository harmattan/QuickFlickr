import QtQuick 1.1
import QtMobility.location 1.2

import com.nokia.meego 1.0

BasePage {
    id: rootLocationView
    signal itemClicked(int index)
    property int currentPageIndex: 1
    property int lastPageIndex: 1
    property bool loading: false
    property bool clearView: true
    property Coordinate currentPosition: positionSource.position.coordinate
    property Coordinate clickedImagePosition: click
    property Coordinate lastPos
    noContentText: "Searching..."
    onCurrentPageIndexChanged: console.log("Current page index: " + currentPageIndex)
    Coordinate{
        id: click
    }

    function showClickedItem(index)
    {
        clearView = false;
        itemClicked(index);
    }

    onStatusChanged: {
        if ( status == PageStatus.Active){
            positionSource.active = true;
            console.log("Loading LocationView");
        }

        if ( status == PageStatus.Inactive ){
            console.log("Unloading LocationView");
            positionSource.active = false;
            if (clearView){
                positionSource.firstRun = true;
                positionSource.lastLat = 0.0;
                positionSource.lastLon = 0.0;
                rootLocationView.currentPageIndex = 1;
                rootLocationView.clearView = false;
            }
        }
    }



    PositionSource {
        id: positionSource
        updateInterval: 30000
        property real lastLon: 0.0
        property real lastLat: 0.0
        property bool firstRun: true

        function distance(lat1, lon1, lat2, lon2)
        {
            var R = 6371; // km
            var d = Math.acos(Math.sin(lat1)*Math.sin(lat2) +
                              Math.cos(lat1)*Math.cos(lat2) *
                              Math.cos(lon2-lon1)) * R;
            console.log("Distance: " + d);
            return d;
        }

        onPositionChanged: {
            if (position.longitudeValid &&
                position.latitudeValid){


                if ( firstRun){
                    lastLat = position.coordinate.latitude;
                    lastLon = position.coordinate.longitude;
                    firstRun = false;
                    flickrManager.searchLocation(position.coordinate.longitude,
                                                 position.coordinate.latitude, 1);
                    loading = true;
                    return;
                }

                if ( distance(lastLat, lastLon, position.coordinate.latitude,
                              position.coordinate.longitude) > 3){

                    flickrManager.searchLocation(position.coordinate.longitude,
                                                 position.coordinate.latitude, 1);
                    loading = true;
                    lastLat = position.coordinate.latitude;
                    lastLon = position.coordinate.longitude;
                    rootLocationView.currentPageIndex = 1;
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
                console.log("Model count " + locationModel.count);
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
            text: "Latitude: " + (positionSource.position.latitudeValid?positionSource.position.coordinate.latitude: "...")
            color: "white"
        }
        Label{
            text: "Longitude: " +(positionSource.position.longitudeValid?positionSource.position.coordinate.longitude: "...")
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
        onClicked: rootLocationView.showClickedItem(index);
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
