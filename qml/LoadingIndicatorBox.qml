import QtQuick 1.0

Rectangle{
    property variant scrollArea
    property alias text: text.text
    property int contentY: scrollArea.contentY
    signal textShowed()
    height:  settings.loadMoreThreshold//Math.abs(scrollArea.contentY)
    width:  scrollArea.width
    color: "#11111101"
    opacity: 0
    scale:  0

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

        if (contentY >= bottomThreshold){
            opacity=1.0;
            scale = 1;
        }
        if (contentY <= -settings.loadMoreThreshold){
            opacity= 1.0;
            scale = 1;
        }
        if ( -settings.loadMoreThreshold < contentY &&  contentY < bottomThreshold ){
            opacity= 0;
            scale = 0;
        }
    }

    Behavior on opacity {NumberAnimation{ duration: 200}}
    Behavior on scale{NumberAnimation{ duration: 300}}

}

