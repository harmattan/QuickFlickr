#DEFINES += LITE
TEMPLATE = app
TARGET = quickflickr

contains(DEFINES, LITE) {
    TARGET = quickflickr-lite
}


CONFIG   -= app_bundle
# enable booster
CONFIG += qdeclarative-boostable
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic

QT += declarative network xml webkit
#QMAKE_CXXFLAGS = -O2



INCLUDEPATH += src kqoauth/src
MOC_DIR = moc
OBJECTS_DIR = objs
KQOAUTH_DIR= kqoauth/src

mac{
    QT += opengl
}

maemo5{
    QT += dbus opengl
}

RESOURCES += \
    quickflickr.qrc


# kqoauth files
HEADERS += \
    $$KQOAUTH_DIR/kqoauthmanager.h \
    $$KQOAUTH_DIR/kqoauthrequest.h \
    $$KQOAUTH_DIR/kqoauthrequest_1.h \
    $$KQOAUTH_DIR/kqoauthrequest_xauth.h \
    $$KQOAUTH_DIR/kqoauthglobals.h \
    $$KQOAUTH_DIR/kqoauthrequest_p.h \
    $$KQOAUTH_DIR/kqoauthmanager_p.h \
    $$KQOAUTH_DIR/kqoauthauthreplyserver.h \
    $$KQOAUTH_DIR/kqoauthauthreplyserver_p.h \
    $$KQOAUTH_DIR/kqoauthutils.h \
    $$KQOAUTH_DIR/kqoauthrequest_xauth_p.h \
    src/settings.h \
    src/keys.h


SOURCES += \
     $$KQOAUTH_DIR/kqoauthmanager.cpp \
     $$KQOAUTH_DIR/kqoauthrequest.cpp \
     $$KQOAUTH_DIR/kqoauthutils.cpp \
     $$KQOAUTH_DIR/kqoauthauthreplyserver.cpp \
     $$KQOAUTH_DIR/kqoauthrequest_1.cpp \
     $$KQOAUTH_DIR/kqoauthrequest_xauth.cpp \
    src/settings.cpp


DEFINES += KQOAUTH

# quickflickr files
SOURCES += \
    src/main.cpp \
    src/qmlloader.cpp \
    src/flickrmanager.cpp \
    src/flickroauth.cpp \
    src/utils.cpp

HEADERS += \
    src/qmlloader.h \
    src/flickrmanager.h \
    src/flickroauth.h \
    src/flickroauth_p.h \
    src/utils.h


OTHER_FILES += \
    qml/QuickFlickrMain.qml \
    qml/Button.qml \
    qml/MenuButton.qml \
    qml/FlickableWebView.qml \
    qml/ScrollBar.qml \
    qml/RecentActivityModel.qml \
    qml/CommentModel.qml \
    qml/CommentsView.qml \
    qml/FavoritesModel.qml \
    qml/FlickrImage.qml \
    qml/BrowserButton.qml \
    qml/Loading.qml \
    qml/Page.qml \
    qml/NavigationBar.qml \
    qml/Settings.qml \
    qml/Timelineview.qml \
    qml/TimelineDelegate.qml \
    qml/PhotostreamView.qml \
    qml/PhotostreamModel.qml \
    qml/PhotoDetailsView.qml \
    qml/UserInfoModel.qml \
    qml/UserInfoDelegate.qml \
    qml/FlickrText.qml \
    qml/LineSeparator.qml \
    qml/IconButton.qml \
    qml/RadioIconButton.qml \
    qml/PhotoDetailsModel.qml \
    qml/PhotoDetailsDelegate.qml \
    qml/AddCommentView.qml \
    qml/ContactUploadsModel.qml \
    qml/ContactListModel.qml \
    qml/ContactListView.qml \
    qml/FavoritesView.qml \
    qml/ThumbnailDelegate.qml \
    qml/ThumbnailView.qml \
    qml/RecentActivityView.qml \
    qml/SettingsView.qml \
    qml/AuthenticationView.qml \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/PhotoViewerView.qml \
    qml/BasePage.qml \
    qml/PhotoViewerDelegate.qml \
    qml/ZoomableImage.qml \
    qml/PhotoDetailsLayer.qml \
    qml/DigitField.qml \
    qml/FavesList.qml \
    qml/FavesModel.qml \
    qml/NoContentText.qml \
    qml/PolaroidImage.qml \
    qml/AvatarWithTextDelegate.qml \
    qml/PatchIcon.qml \
    qml/LoadingIndicatorBox.qml \
    qml/SearchView.qml \
    qml/LocationView.qml \
    qml/LocationModel.qml \
    qml/MapView.qml


OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    quickflickr.desktop \
    quickflickr-lite.desktop \
    quickflickr.svg \
    quickflickr.png \
    quickflickr-lite.png


# Please do not modify the following two lines. Required for deployment.
include(deployment.pri)
qtcAddDeployment()

!exists("kqoauth/.git/config"){
    system("git clone git@gitorious.org:kqoauth/kqoauth.git")
}

#system(cp gfx/quickflickr.png ./quickflickr.png)
#contains(DEFINES, LITE) {
#    system(cp gfx/quickflickr-lite.png ./quickflickr.png)
#}










