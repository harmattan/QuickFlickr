import Qt 4.7

Item{    
    signal commentAdded
    property string photoId            
    
    Text{
        id: titleText   
        text: "Add Comment:"
        font.family: "Helvetica"
        font.pointSize: 22
        font.bold: true
        color: "white"
        smooth: true          
        anchors.topMargin: 10
        anchors.bottom:  background.top
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    
    BorderImage {
        source: "qrc:/images/toolbutton.sci"
        smooth: true
        opacity: 0.3            
        id: background
        width: 550
        height:  220
    }
    
    
    
    Flickable {
        id: textField   
        anchors.fill: background
        anchors.rightMargin: 10
        anchors.leftMargin: 10        
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        contentWidth: textEdit.paintedWidth
        contentHeight: textEdit.paintedHeight
        height:  200
        clip: true
   
        function ensureVisible(r)
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }
   
       
            
        TextEdit {
            id:textEdit
            width: textField.width
            height: textField.height            
            wrapMode: TextEdit.Wrap
            onCursorRectangleChanged: textField.ensureVisible(cursorRectangle)
            color: "white"
            font.pixelSize: 20
            font.family: "Helvetica"
        }
        
        ScrollBar {            
            scrollArea: textField; width: 8
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom; bottomMargin:5; topMargin:5 }                        
            
        }
   
    }

    Button{ 
        id: addButton
        text: "Add"        
        anchors.right: parent.right
        anchors.top:  background.bottom        
        anchors.topMargin: 10
        anchors.rightMargin: 10
        onClicked:{
            if ( textEdit.text != "" ){
                flickrManager.addComment(photoId, textEdit.text);
                textEdit.text = "";       
                parent.commentAdded();                
            }

            fullScreenDelegate.state = "Details";            
            flipable.state = 'back';
            
        }
    }

}
