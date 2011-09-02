/**
 * QuickFlickr - Flickr client for mobile devices.
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
import QtQuick 1.1


XmlListModel {
    
    query: "/rsp/items/item"    
    XmlRole { name: "title"; query: "title/string()" }    
    XmlRole { name: "type"; query: "@type/string()" }
    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "owner"; query: "@owner/string()" }
    XmlRole { name: "ownername"; query: "@ownername/string()" }
    XmlRole { name: "secret"; query: "@secret/string()" }
    XmlRole { name: "server"; query: "@server/string()" }
    XmlRole { name: "farm"; query: "@farm/string()" }    
    XmlRole { name: "comments"; query: "@comments/string()" }
    XmlRole { name: "faves"; query: "@faves/string()" }
    XmlRole { name: "views"; query: "@views/string()" }
    XmlRole { name: "notes"; query: "@notes/string()" }            
    XmlRole { name: "eventtype"; query: "activity/event/@type/string()" }
     
}
