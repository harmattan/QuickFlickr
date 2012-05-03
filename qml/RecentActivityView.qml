import QtQuick 1.1
import com.nokia.meego 1.0
BasePage{
    id: recentActivityView
    signal thumbnailClicked( string photoId, url photoUrl )
    signal getFavorites( string photoId, url photoUrl)
    signal getComments( string photoId, url photoUrl)
    property bool isModelUpdated: false
    property int currentItemIndex: 0
    noContentText: "Loading Activities"

    function defaultState()
    {
        state = "";
    }

    Connections{
        target: flickrManager
        onRecentActivityUpdated: { activityModel.xml = xml;  recentActivityView.isModelUpdated=true}
    }


    RecentActivityModel{
        id: activityModel
        onStatusChanged: {
            recentActivityView.handleStatusText(activityModel, "Activities");
        }
    }

    // Delegate
    Component{
        id: del
        Item{
            property url mediumSizeUrl: "http://farm"+farm+".static.flickr.com/"+server+"/"+id+"_"+secret+".jpg"
            width: settings.pageWidth
            height: settings.pageHeight

            Label{
                id: titleText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: image.top
                anchors.margins: settings.largeMargin
                width: parent.width
                //anchors.horizontalCenter: image.horizontalCenter
                color: "white"
                text: ( title === ""? "No Title": title)
                smooth: true                
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: settings.hugeFontSize * 0.7
                font.capitalization: Font.AllLowercase
            }
            PolaroidImage{
                id: image
                property int size:  settings.portrait?460:380
                source: "http://farm"+farm+".static.flickr.com/"+server+"/"+id+"_"+secret+".jpg"
                width: size
                height: size
                anchors.centerIn: parent
                Behavior on width { NumberAnimation{ duration: 500}}
                Behavior on height { NumberAnimation{ duration: 500}}
            }
            PatchIcon{
                id: favesIcon
                anchors.top:   image.bottom
                anchors.left:  image.left
                anchors.margins: settings.hugeMargin
                enabledIconSource: "qrc:///gfx/favorite-on.png"
                disabledIconSource: "qrc:///gfx/favorite-off.png"
                onClicked: { flickrManager.getPhotoFavorites(id); recentActivityView.state = "showFaves"}
                number: faves
                enabled: faves != "0"
            }
            PatchIcon{
                id: viewsIcon
                anchors.top:  image.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: settings.hugeMargin
                enabledIconSource: "qrc:///gfx/views.png"
                number: views
            }
            PatchIcon{
                id: commentsIcon
                anchors.top: image.bottom
                anchors.right: image.right
                anchors.margins: settings.hugeMargin
                number: comments
                enabledIconSource: "qrc:///gfx/comments-on.png"
                disabledIconSource: "qrc:///gfx/comments-off.png"
                enabled: comments != "0"
                onClicked: {flickrManager.getComments(id); recentActivityView.state = "showComments" }
            }

            states: State{
                name: "landscapeLayout"
                when:  !settings.portrait
                AnchorChanges{
                    target: favesIcon
                    anchors.top: image.top
                    anchors.left: image.right
                    anchors.right: undefined
                    anchors.bottom: undefined
                }
                AnchorChanges{
                    target: viewsIcon
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: image.verticalCenter
                    anchors.top: undefined
                    anchors.left: image.right
                }
                AnchorChanges{
                    target: commentsIcon
                    anchors.bottom: image.bottom
                    anchors.left: image.right
                    anchors.top: undefined
                    anchors.right: undefined
                }
            }

            transitions: [
                Transition {
                    AnchorAnimation{ duration: 700 }
                }
            ]
        }
    }

    ListView {
        anchors.fill: parent
        model:  activityModel
        delegate: del
        spacing:  settings.hugeMargin * 2
        cacheBuffer: settings.pageHeight
        snapMode: ListView.SnapOneItem
        flickDeceleration: 600
        currentIndex: recentActivityView.currentItemIndex
        onCurrentIndexChanged: {recentActivityView.currentItemIndex = currentIndex;}
        highlightRangeMode: ListView.StrictlyEnforceRange
    }

    FavesList{
        id: photoFavesList
        anchors.fill: parent
        onClose: {recentActivityView.state = ""; photoFavesList.clear() }
        opacity: 0
    }

    CommentsView{
        id: photoCommentsList
        onClose: {recentActivityView.state = ""; photoCommentsList.clear() }
        anchors.fill: parent
        anchors.bottomMargin: settings.mediumMargin
        opacity: 0
    }

    Loader{
        visible:  (activityModel.status != XmlListModel.Ready && !parent.showNoContent)
        anchors.centerIn: parent
    }


    states: [
        State{
            name: "showFaves"
            PropertyChanges{
                target: photoFavesList
                opacity: 1
            }

        },
        State{
            name: "showComments"
            PropertyChanges{
                target: photoCommentsList
                opacity: 1
            }
        }

    ]

    transitions: [
        Transition {
            //AnchorAnimation{ duration: 400 }
            NumberAnimation {  property: "opacity";  duration: 800 }
        }
    ]

}
