import Qt 4.7
// Simple delegate which displays some common information about a
// single image from flickr. This delegate scales all the thumbnails
// to fixed width.
Item{    
    id: contactListDelegate
    width: contactList.width - 20
    height: 100
    x: 10        


    BorderImage{
        id: background
        source: "qrc:/images/toolbutton.sci"
        smooth: true
        opacity: 0.3
        anchors.fill: parent
        
        states: [
            State {
                name: "Pressed"
                PropertyChanges { target: background; opacity: 0.8}                
            }
        ]
        
        transitions: Transition {
                 PropertyAnimation { properties: "opacity";  easing.type: "OutCubic"; duration:200 }              
        }
    }

    MouseArea{
        anchors.fill: parent

        onPressed: { background.state = 'Pressed' }
        onReleased: { background.state = 'Default'}
        onClicked: {
            mainFlipable.state = 'back';
            flickrManager.getPhotosOfContact(owner);            
        }

        onPressAndHold: {            
            mainMenu.state = 'Menu';  
        }
    }


    // Container for an image so that we can center
    // all the images and make texts align perfectly
    FlickrImage{
        id: thumbnail_
        width: 75
        height: 75
        sourceSize.height: height
        sourceSize.width: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        source: "http://farm"+farm+".static.flickr.com/"+server+"/"+id+"_"+secret+"_s.jpg"        
    }
    
    // Title section
    Text{
        id: title_
        elide: Text.ElideRight
        width: parent.width - thumbnail_.width - 10
        text: title; font.family: "Helvetica"; font.bold: true; font.pixelSize: 22; color: "white"
        anchors.top: parent.top
        anchors.left: thumbnail_.right
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.topMargin: 10
        anchors.rightMargin: 10
    }

    // Username section
    Text{
        id: userName_
        elide: Text.ElideRight
        width: parent.width - thumbnail_.width - 10
        text: qsTr("by ") + username;
        font.family: "Helvetica";
        font.pixelSize: 20;
        color: "white"
        smooth: true
        anchors.top: title_.bottom
        anchors.left: thumbnail_.right
        anchors.topMargin: 5
        anchors.leftMargin: 20
    }

    // Date taken section
    Text{
        id: dateTaken_
        text: qsTr("Date Taken: ") + datetaken;
        font.family: "Helvetica";
        font.pixelSize: 15;
        color: "white"
        anchors.top: userName_.bottom
        anchors.left: thumbnail_.right
        anchors.topMargin: 5
        anchors.leftMargin: 20
    }
        
    ListView.onAdd: NumberAnimation { target: contactListDelegate; property: "scale"; from: 0.0; to: 1.0; duration: 250; easing.type: Easing.InOutQuad }                 
             
         
    
}








