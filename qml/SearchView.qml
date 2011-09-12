import QtQuick 1.0
import com.meego 1.0

BasePage{
    id: rootSearchView
    signal thumbnailClicked(string photoId, url photoUrl, int index)
    property int currentPageIndex: 1
    property int lastPageIndex: 1
    property bool ownPhotos: ownPhotosCheckBox.checked
    property bool loading: false
    noContentText: "Search"

    Component.onCompleted: {setInitialValues();}


    Connections{
        target: flickrManager
        onTagSearchUpdated: { searchModel.xml = xml; loading = false;}
        onTextSearchUpdated: { searchModel.xml = xml; loading = false;}
    }

    function setInitialValues()
    {
        searchText.text = qfStore.stringValue("search_text","Nokia N9");
        ownPhotosCheckBox.checked = qfStore.boolValue("own_photos_checked", false);
        tagsButton.checked = qfStore.boolValue("tags_checked", true);
        freeButton.checked = qfStore.boolValue("free_checked", false);
    }

    function saveValues()
    {
        qfStore.setValue("search_text",searchText.text);
        qfStore.setValue("own_photos_checked", ownPhotosCheckBox.checked);
        qfStore.setValue("tags_checked", tagsButton.checked);
        qfStore.setValue("free_checked", freeButton.checked);
    }

    function clearAll()
    {
        photostreamModel.xml = "";
        userInfoModel.xml = "";
        lastPageIndex = 1;
    }

    function clearGrid()
    {
        if (flickrManager.isLiteVersion()){
            return;
        }

        searchModel.xml = "";
        loading = true;
        lastPageIndex = 1;
    }

    function runSearch(reset)
    {
        if ( searchText.text == ""){
            return;
        }

        if (reset){
            currentPageIndex = 1;
        }

        if ( tagsButton.checked ){
            console.log("Text: " + searchText.text + ", " +currentPageIndex + ", "+ownPhotosCheckBox.checked);
            flickrManager.searchTags( searchText.text, currentPageIndex, ownPhotosCheckBox.checked )
        }
        else
        if ( freeButton.checked ){
            console.log("Text: " + searchText.text + ", " +currentPageIndex + ", "+ownPhotosCheckBox.checked);
            flickrManager.searchFreeText( searchText.text, currentPageIndex, ownPhotosCheckBox.checked )
        }

        saveValues();
    }

    // Function to get next search page
    function nextSearchPage()
    {
        if (currentPageIndex == lastPageIndex){
            return;
        }
        if (flickrManager.isLiteVersion() && currentPageIndex == 1){
            flickrManager.notifyNotSupported();
            return;
        }

        clearGrid();
        ++currentPageIndex;
        runSearch(false);
    }

    // Function to get previous photostream page
    function prevSearchPage()
    {
        if ( currentPageIndex == 1){
            return;
        }


        clearGrid();
        --currentPageIndex;
        runSearch(false);
    }

    PhotostreamModel{
        id: searchModel
        onStatusChanged:{
            rootSearchView.handleStatusText(searchModel, "Photos");

            if ( status == XmlListModel.Ready){
                lastPageIndex = utils.lastPageIndex(searchModel.xml);
            }
        }
    }

    CheckBox{
        id: ownPhotosCheckBox
        anchors.left: parent.left
        anchors.top: parent.top
        text: "<font color=\"white\">My Photos</font>"
        onClicked: {rootSearchView.runSearch(true); console.log("OnClicked: "+ checked);}
    }

    ButtonRow{
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: ownPhotosCheckBox.right
        anchors.leftMargin: settings.hugeMargin
        RadioButton { id: tagsButton; text: "<font color=\"white\">Tags</a>"; onClicked: rootSearchView.runSearch(true)}
        RadioButton { id: freeButton; text: "<font color=\"white\">Free Text</a>"; onClicked: rootSearchView.runSearch(true)}
        spacing: 10
    }

    TextField{
        id: searchText
        anchors.top: ownPhotosCheckBox.bottom
        anchors.topMargin: settings.largeMargin
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: settings.mediumMargin
        placeholderText: "Comma separated list of tags"

        SipAttributes {
             id: sipAttributes
             actionKeyLabel: "Done"
             actionKeyEnabled: true
         }

         platformSipAttributes: sipAttributes
         Keys.onReturnPressed: {
             parent.focus = true;
             rootSearchView.runSearch(true);
         }
    }


    // Grid for thumbnails
    ThumbnailView{
        id: searchGrid
        anchors.top: searchText.bottom
        anchors.topMargin: settings.mediumMargin
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: parent.bottom
        model: searchModel
        loading: parent.loading
        onClicked: parent.thumbnailClicked(photoId, photoUrl, index );
        onLoadNextThumbnails: nextSearchPage();
        onLoadPreviousThumbnails: prevSearchPage();
    }

}
