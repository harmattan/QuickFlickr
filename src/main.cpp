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
#include <QApplication>
#include "qmlloader.h"
#include <QtDebug>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setDoubleClickInterval(500);

    Q_INIT_RESOURCE(quickflickr);
    
    // Simple loader for loading QML files
    QmlLoader loader;

    // Platform specific stuff. Not so nice, but should work
    //app.setGraphicsSystem("raster");
    loader.showFullScreen();
    return app.exec();

#if defined(Q_WS_MAC) || defined(Q_WS_X11)
        loader.resize(360,640);
        loader.show();
        return app.exec();
#endif

}
