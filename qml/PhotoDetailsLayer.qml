import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: rootDetailsLayer
    property bool isVisible:  state != ""
    property string photoId:""

    state:  ""
    onStateChanged: {if (state == "") timer.start();}


    function addOrRemoveFavorite()
    {
        console.log( "AddOrRemoveFavorite: is fave:" + rootDetailsLayer.isFavorite()?"true":"false" +"," +id);

        if ( rootDetailsLayer.isFavorite() == 0 ){
            flickrManager.addFavorite(photoId);
        }else{
            flickrManager.removeFavorite(photoId);
        }
    }

    function addComment()
    {

        if ( rootDetailsLayer.state != "showAddComment"){
            addCommentView.photoId = photoId;
            rootDetailsLayer.state = "showAddComment";
        }else{
            rootDetailsLayer.state = "showButtons";
        }
    }

    function showComments()
    {
        if ( rootDetailsLayer.state != "showComments"){
            flickrManager.getComments(photoId);
            rootDetailsLayer.state = "showComments";
        }else{
            rootDetailsLayer.state = "showButtons";
        }
    }

    function showDescription()
    {
        if ( rootDetailsLayer.state != "showDescription"){
            flickrManager.getComments(photoId);
            rootDetailsLayer.state = "showDescription";
        }else{
            rootDetailsLayer.state = "showButtons";
        }
    }

    function hide()
    {
        if ( state != ""){
            state = "";
        }
    }

    function show()
    {
        if ( state != "showButtons"){
                state = "showButtons";
        }
    }


    function isFavorite()
    {
        if ( detailsModel.get(0).isfavorite == 0){
                return false;
        }else{
                return true;
        }
    }

    function getDescription()
    {
        var description = detailsModel.get(0).description;
        if (description == ""){
            return "No Description available";
        }else{
            return description;
        }
    }

    function updateData()
    {
        titleText.text = detailsModel.get(0).title;
        author.text =  detailsModel.get(0).username;
        viewsText.text = detailsModel.get(0).views;
        commentsText.text =  detailsModel.get(0).comments;
        dateText.text = detailsModel.get(0).datetaken.split(" ")[0];
        photoId = detailsModel.get(0).id;
        favoriteButton.checked = isFavorite();
        commentsView.photoId = photoId;
        descriptionText.text = getDescription();
        commentsButton.enabled = detailsModel.get(0).comments != 0
    }

    function clearData()
    {
        detailsModel.xml = "";
        titleText.text = "";
        author.text =  "";
        viewsText.text = "";
        commentsText.text =  "";
        dateText.text = "";
        photoId = "";
        commentsView.photoId = "";
        descriptionText.text = "";        
    }

    Connections{
        target: flickrManager
        onPhotoInfoUpdated: {detailsModel.xml = xml; }
        onCommentAdded: flickrManager.getPhotoInfo(photoId);
    }

    PhotoDetailsModel{
        id: detailsModel
        onStatusChanged: {if (status == XmlListModel.Ready){rootDetailsLayer.updateData(); rootDetailsLayer.state = "showButtons";}}
    }


    Timer{
        id: timer
        interval: 800
        running: false
        repeat: false
        onTriggered: rootDetailsLayer.clearData()
    }

    // Info at the top
    Item{
        id: titleBar
        z: 2
        height: childrenRect.height
        anchors.bottom:  rootDetailsLayer.top
        anchors.bottomMargin: settings.hugeMargin
        anchors.left: rootDetailsLayer.left
        anchors.right: rootDetailsLayer.right


        Rectangle{
            id: titleBarBg
            anchors.fill: parent
            color: "black"
            opacity: 0.8
        }

        Text{
            id: titleText
            color: "white"
            smooth: true
            anchors.top: titleBar.top
            anchors.left: titleBar.left
            anchors.right: titleBar.right
            anchors.leftMargin: settings.mediumMargin
            height: paintedHeight
            elide: Text.ElideRight
            font.pixelSize: settings.largeFontSize
        }

        Text{
            id: author
            color: "white"
            smooth: true
            anchors.top: titleText.bottom
            anchors.left: titleText.left
            anchors.right: titleText.right
            anchors.rightMargin: settings.mediumMargin
            height: paintedHeight
            elide: Text.ElideRight
            font.pixelSize: settings.mediumFontSize
            horizontalAlignment: Text.AlignLeft
        }

        FlickrText{
            id:viewsText
            header: "Views"
            anchors.top: author.bottom
            anchors.left: author.left
            anchors.topMargin: settings.mediumMargin
        }
        FlickrText{
            id: commentsText
            header: "Comments"
            anchors.top: viewsText.top
            anchors.left: viewsText.right
            anchors.leftMargin: settings.mediumMargin
        }
        FlickrText{
            id: dateText
            header: "Date"
            anchors.top:viewsText.top
            anchors.left: commentsText.right
            anchors.leftMargin: settings.mediumMargin
        }

    }
    // End of the title bar

    // Description area in the middle
    Item{
        id: descriptionArea

        anchors.top: titleBar.bottom
        anchors.bottom: buttons.top
        anchors.left: parent.left
        anchors.right: parent.right
        opacity: 0

        // Placeholder for a graphics
        Rectangle{
            id: descriptionAreaBg
            anchors.fill: parent
            color: "black"
            opacity: 0.8
        }
        Flickable{
            id: flickableDescriptionText
            anchors.fill: descriptionAreaBg
            anchors.margins: settings.mediumMargin
            contentHeight: descriptionText.paintedHeight
            clip:  true
            Label{
                id: descriptionText
                y: settings.mediumMargin
                //text: {if (description != "" )return description; else return "No Description"; }
                width: settings.pageWidth - (2* settings.mediumMargin)
                wrapMode: Text.Wrap
                smooth:  true                
                color: "white"
                opacity: 1
                clip: true
                textFormat: Text.RichText
                onLinkActivated:Qt.openUrlExternally(link)
            }
        }
    }
    // End of the description area


    // Comment field
    CommentsView{
        id: commentsView        
        anchors.top: titleBar.bottom
        anchors.bottom: buttons.top
        anchors.left: parent.left
        anchors.right: parent.right
        opacity: 0
    }
    // end of comment field

    // Add Comment Field
    AddCommentView{
        id: addCommentView        
        anchors.top: titleBar.bottom
        anchors.bottom: buttons.top
        anchors.left: parent.left
        anchors.right: parent.right
        opacity: 0
        onCommentAdded: {rootDetailsLayer.state = "showButtons"}
        onCancelClicked: rootDetailsLayer.state = "showButtons"

    }
    // end of add comment field



    // Buttons at the bottom
    Item{
        id: buttons
        anchors.top: rootDetailsLayer.bottom
        anchors.topMargin: settings.largeMargin
        anchors.left: rootDetailsLayer.left
        anchors.right: rootDetailsLayer.right
        anchors.bottomMargin: settings.smallMargin

        height: favoriteButton.height + 2*settings.mediumMargin
        z: 2

        Rectangle{
            id: buttonsBg
            color: "black"
            opacity: 0.8
            anchors.fill: parent
        }

        Row{
            anchors.fill: parent
            anchors.margins: settings.smallMargin
            height: favoriteButton.height * 1.2;

            spacing:  (settings.pageWidth-settings.mediumMargin*2-commentsButton.width*4) /3

            RadioIconButton{
                id: favoriteButton
                checkedIconSource: "qrc:///gfx/favorite-on.png"
                uncheckedIconSource: "qrc:///gfx/favorite-off.png"                
                onClicked: addOrRemoveFavorite()
            }

            IconButton{
                id: descriptionButton
                enabledIconSource: "qrc:///gfx/details.png"
                enabled: true
                onClicked: showDescription();
            }

            IconButton{
                id: commentsButton
                enabledIconSource: "qrc:///gfx/comments-on.png"
                disabledIconSource: "qrc:///gfx/comments-off.png"
                onClicked: showComments();
            }
            IconButton{
                id: addCommentsButton
                enabledIconSource: "qrc:///gfx/add-comment.png"
                onClicked: addComment();
            }
        }

    }

    // States for managing what should appear....
    states:[
        State{
            name: "showButtons"            
            AnchorChanges{
                target: buttons
                anchors.bottom: rootDetailsLayer.bottom
                anchors.top: undefined
            }

            AnchorChanges{
                target: titleBar
                anchors.bottom: undefined
                anchors.top: rootDetailsLayer.top
            }            
        },
        State{
            name: "showComments"
            extend: "showButtons"            
            PropertyChanges {
                target: commentsView
                opacity: 1
            }
        },
        State{
            name: "showAddComment"
            extend: "showButtons"            
            PropertyChanges {
                target: addCommentView
                opacity: 1
            }
        },
        State{
            name: "showDescription"
            extend: "showButtons"

            PropertyChanges {
                target: descriptionArea
                opacity: 1
            }
        }

    ]

    transitions: [
        Transition {
            AnchorAnimation{ duration: 400; easing.type: Easing.InOutQuad}
            PropertyAnimation{ property: "opacity"; duration: 800}
        }
    ]

}
