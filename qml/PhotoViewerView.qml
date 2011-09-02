import QtQuick 1.1
import com.meego 1.0

BasePage{
    id: rootPhotoViewerPage
    property int startIndex: -1
    property int currentItemIndex: 0
    property int currentPageIndex: 1
    property alias xml:  viewerModel.xml
    property int lastPageIndex: 1
    property bool loading:  false
    signal loadNextImages()
    signal loadPreviousImages()

    function positionViewAtIndex(index)
    {
        photosList.positionViewAtIndex(index, ListView.Beginning);
        currentItemIndex = index;
    }

    onStatusChanged: { if( status == PageStatus.Activating) {positionViewAtIndex(currentItemIndex, ListView.Center); }}

    PhotostreamModel{
        id: viewerModel
        onStatusChanged: {
            if (status == XmlListModel.Ready){
                if ( viewerModel.xml.length == 0){
                    return;
                }

                if (startIndex != -1){
                    positionViewAtIndex(startIndex);
                    startIndex = -1;
                }

                lastPageIndex = utils.lastPageIndex(viewerModel.xml);
                loading = false;
            }
        }
    }

    LoadingIndicatorBox{
        id: topIndicator
        scrollArea: photosList
        text:  "Loading previous"
        anchors.top: photosList.top
        anchors.topMargin: settings.hugeMargin
        onTextShowed: detailsLayer.hide()
    }
    LoadingIndicatorBox{
        id: bottomIndicator
        scrollArea: photosList
        text:  "Loading next"
        anchors.bottom: photosList.bottom
        anchors.bottomMargin: settings.hugeMargin
        onTextShowed: detailsLayer.hide()
    }

    // This is the main list view for showing fullscreen images
    ListView{
        id: photosList
        property bool loadNext
        property bool thresholdExceeded:  false
        property int thresholdValue:  80
        property int lastPhotoId:0
        anchors.fill: parent
        orientation: ListView.Vertical
        snapMode: ListView.SnapOneItem
        model:  viewerModel
        delegate:  PhotoViewerDelegate{}
        cacheBuffer: settings.pageHeight
        spacing: settings.largeMargin
        highlightRangeMode: ListView.StrictlyEnforceRange
        currentIndex: rootPhotoViewerPage.currentItemIndex
        onCurrentIndexChanged: {rootPhotoViewerPage.currentItemIndex = currentIndex;  detailsLayer.hide(); }

        // Movement stuff handles when swiping to the begining or to the end
        onContentYChanged: {

            if ( (contentY + height) > (contentHeight + thresholdValue)){
                thresholdExceeded = true;
                loadNext = true;
            }
            if (contentY < -thresholdValue){
                thresholdExceeded = true;
                loadNext = false;
            }
        }

        onMovementEnded: {
            if ( !thresholdExceeded || rootPhotoViewerPage.loading){
                return;
            }


            thresholdExceeded = false;
            if ( loadNext && currentPageIndex < lastPageIndex){
                startIndex = 0;
                rootPhotoViewerPage.loadNextImages();
                rootPhotoViewerPage.loading = true;
                detailsLayer.hide();
            }
            if (!loadNext && currentPageIndex > 1){
                startIndex = viewerModel.count -1;
                rootPhotoViewerPage.loadPreviousImages();
                rootPhotoViewerPage.loading = true;
                detailsLayer.hide();
            }
        }
    }

    PhotoDetailsLayer{
        id: detailsLayer
        anchors.fill: parent
    }
}
