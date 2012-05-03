/**
 * QuickFlickr - FlickrClient for mobile devices.
 *
 * Author: Marko Mattila (marko.mattila@d-pointer.com)
 *         http://www.d-pointer.com
 *
 *  QuickFlickr is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  QuickFlickr is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with QuickFLickr.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <MDeclarativeCache>
#include <QDeclarativeView>
#include <QDeclarativeContext>
#include <QScopedPointer>
#include <QApplication>
//#include "qmlloader.h"
#include <QtDebug>
#include "flickrmanager.h"
#include "utils.h"
#include "settings.h"


Q_DECL_EXPORT int main(int argc, char *argv[])
{

    //QApplication app(argc, argv);

    QScopedPointer<QApplication> app(MDeclarativeCache::qApplication(argc, argv));
    QScopedPointer<QDeclarativeView> window(MDeclarativeCache::qDeclarativeView());
    app->setDoubleClickInterval(500);

    QCoreApplication::setOrganizationName("d-pointer");
#ifdef LITE
    QCoreApplication::setApplicationName("quickflickr-lite");
#else
    QCoreApplication::setApplicationName("quickflickr");
#endif

    Q_INIT_RESOURCE(quickflickr);

    FlickrManager flickrManager;
    Settings settings;

    // Expose the C++ interface to QML
    window->rootContext()->setContextProperty("flickrManager", &flickrManager );
    window->rootContext()->setContextProperty("qfStore", &settings );
    window->rootContext()->setContextProperty("utils", Utils::instance() );

    window->setSource(QUrl("qrc:///qml/qml/QuickFlickrMain.qml"));
    flickrManager.activate();
    // Simple loader for loading QML files
    //QmlLoader loader;

    // Platform specific stuff. Not so nice, but should work    
    //loader.showFullScreen();
    window->showFullScreen();
    return app->exec();

}
