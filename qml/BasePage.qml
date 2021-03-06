import QtQuick 1.1
import com.nokia.meego 1.1

Page{
    width: settings.pageWidth
    height: settings.pageHeight
    tools: navigationTools
    property bool showNoContent: false
    property alias noContentText: noContentTextArea.text
    orientationLock: PageOrientation.LockPortrait


    function handleStatusText(xmlListModel, title)
    {

        if (xmlListModel.xml.length === 0){
            return;
        }

        if ( xmlListModel.status == XmlListModel.Loading){
            noContentText = "Loading " + title;
            showNoContent = true;
            return;
        }

        if ( xmlListModel.status == XmlListModel.Ready){
            if ( xmlListModel.count > 0 ){
                showNoContent = false;
            }
            else
            if (xmlListModel.count == 0){
                showNoContent = true;
                noContentText = "No " + title + "!";
            }
        }

        if ( xmlListModel.status == XmlListModel.Error){
            noContentText = "Error!"
            showNoContent = true;
            return;
        }

    }


    onShowNoContentChanged: {
        if( showNoContent ) {
            noContentTextArea.opacity = 0.5;
        }else{
            noContentTextArea.opacity = 0;
        }
        console.log("Opacity changed to: " + noContentTextArea.opacity );
    }

    Rectangle{
        anchors.fill: parent
        color: settings.defaultBackgroundColor
    }
    /*
    Image{
        anchors.fill: parent
        source: "qrc:///gfx/background.png"
    }
    */

    NoContentText{
        id: noContentTextArea
        anchors.centerIn: parent
    }
}
