import Qt 4.7

Item{
    
    anchors.fill: parent

    // List for showing uploads from contacts
    ListView {
        id: listView
        model: ContactListModel{id:contactListModel }
        spacing: 10
        anchors.fill: parent                
        cacheBuffer: 900 // Removes flickring on top and the bottom        
        clip: true
        delegate: ContactListDelegate{ id: contactListelegate }        
        
        
        ScrollBar {            
            scrollArea: parent; width: 8
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }                        
        }
                            
    }
        
    Loading{        
        id: loaderIndicator        
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Connections{
        target: flickrManager
        onContactsUploadsUpdated: {
            contactListModel.xml = xml;
            loaderIndicator.visible = false;
        }
    }
    
}



