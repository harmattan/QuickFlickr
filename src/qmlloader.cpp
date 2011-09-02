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
#include "qmlloader.h"
#include "flickrmanager.h"
#include "utils.h"

#include <QDeclarativeError>
#include <QDeclarativeContext>
#include <QDeclarativeEngine>
#include <QHBoxLayout>
#include <QtDebug>



QmlLoader::QmlLoader():
        QDeclarativeView()       
{


    setAttribute(Qt::WA_LockPortraitOrientation);
    // Setup the C++ side for providing data for QML
    m_flickrManager = new FlickrManager();    
        
    
    // Expose the C++ interface to QML
    engine()->rootContext()->setContextProperty("flickrManager", m_flickrManager );
    engine()->rootContext()->setContextProperty("mainWindow", this );
    engine()->rootContext()->setContextProperty("utils", Utils::instance() );

    // Load the main QML component which constructs the whole UI from other
    // QML components    
    setSource(QUrl("qrc:///qml/qml/QuickFlickrMain.qml"));
    m_flickrManager->activate();
}

QmlLoader::~QmlLoader()
{
    delete m_flickrManager;
    m_flickrManager = 0;
}









