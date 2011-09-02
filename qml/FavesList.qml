import QtQuick 1.0

Item{
    id: rootFaveList
    width: settings.pageWidth
    height: settings.pageHeight
    signal close()


    function clear()
    {
        photoFavesModel.xml = "";
    }

    Rectangle{
        anchors.fill: parent
        color: settings.defaultBackgroundColor
        opacity:  0.8
    }

    Connections{
        target: flickrManager
        onPhotoFavoritesUpdated: {photoFavesModel.xml = xml; console.log("Photo Fave Model updated");}
    }

    FavesModel{ id: photoFavesModel}

    Component{
        id: photoFaveDelegate

        AvatarWithTextDelegate{
            function getFormattedDate()
            {
                console.log("Fave date: " +utils.formattedTime(parseInt(favedate), "dd.MM.yyyy"));
                 return utils.formattedTime(parseInt(favedate), "dd.MM.yyyy");
            }

            source:   "http://www.flickr.com/buddyicons/"+nsid+".jpg"
            headerText: username
            text: "fave added: " + getFormattedDate();

        }

    }



    ListView{
        model: photoFavesModel
        anchors.fill: parent
        delegate: photoFaveDelegate
        spacing: settings.mediumMargin

        ScrollBar{
            scrollArea: parent
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.rightMargin: 5
        }

        MouseArea{
            anchors.fill: parent
            onClicked: rootFaveList.close();
        }
    }



}
