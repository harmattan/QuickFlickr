import QtQuick 1.0

Rectangle{
    property variant scrollArea
    property alias text: text.text
    property int contentY: scrollArea.contentY
    signal textShowed()
    height:  settings.loadMoreThreshold
    width:  scrollArea.width
    color: "#11111101"
    opacity: 0
    scale:  0
    property bool topLoadingIndicator: true

    Text{
        id: text
        font.pixelSize: settings.largeFontSize * 1.5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: settings.mediumMargin
        color: settings.textHeaderColor
        smooth: true
    }

    onScaleChanged: if ( scale == 1) textShowed();
    onContentYChanged: {        
        var bottomThreshold = Math.abs(scrollArea.contentHeight - scrollArea.height) + settings.loadMoreThreshold;

        if (!topLoadingIndicator && contentY >= bottomThreshold){
            opacity=1.0;
            scale = 1;            
            return;
        }
        if (topLoadingIndicator && contentY <= -settings.loadMoreThreshold){
            opacity= 1.0;
            scale = 1;            
            return;
        }
        if ( -settings.loadMoreThreshold < contentY &&  contentY < bottomThreshold ){
            opacity= 0;
            scale = 0;            
            return;
        }
    }

    Behavior on opacity {NumberAnimation{ duration: 200}}
    Behavior on scale{NumberAnimation{ duration: 300}}

}

