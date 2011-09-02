#-------------------------------------------------
#
# Project created by QtCreator 2010-03-20T10:56:57
#
#-------------------------------------------------


TARGET = quickflickr
CONFIG   -= app_bundle
# enable booster
CONFIG += qdeclarative-boostable
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic

QT += declarative network xml webkit
#QMAKE_CXXFLAGS = -O2


mac{
    QT += opengl
}

maemo5{
    QT += dbus opengl
}

symbian{
    LIBS += -lavkon -leikcore -lcone
    TARGET.CAPABILITY += NetworkServices
    TARGET.EPOCHEAPSIZE = 0x20000 0x8000000
    #TARGET.EPOCSTACKSIZE = 0x80000
    #TARGET.EPOCALLOWDLLDATA = 1
    default_deployment.pkg_prerules += pkg_depends_webkit
}


TEMPLATE = app

INCLUDEPATH += .

MOC_DIR = moc
OBJECTS_DIR = objs

SOURCES += main.cpp \
    qmlloader.cpp \
    flickrmanager.cpp \
    qtflickr.cpp \
    qtflickr_p.cpp \     
    deviceprofile.cpp

HEADERS += \
    qmlloader.h \
    flickrmanager.h \
    qtflickr.h \
    qtflickr_p.h \ 
    deviceprofile.h


OTHER_FILES += \    
    qml/QuickFlickrMain.qml \
    qml/Button.qml \
    qml/MainMenu.qml \
    qml/MenuButton.qml \
    qml/WebBrowser.qml \
    qml/FlickableWebView.qml \
    qml/Header.qml \
    qml/ScrollBar.qml \
    qml/UrlInput.qml \
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
    qml/AuthenticationView.qml





RESOURCES += \
    quickflickr.qrc

