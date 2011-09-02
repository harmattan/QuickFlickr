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

// Model for containing information about users
XmlListModel {

    query: "/rsp/person"
    XmlRole { name: "nsid";         query: "@nsid/string()" }
    XmlRole { name: "ispro";        query: "@ispro/number()" }
    XmlRole { name: "iconserver";   query: "@iconserver/string()" }
    XmlRole { name: "iconfarm";     query: "@iconfarm/string()" }
    XmlRole { name: "realname";     query: "realname/string()" }
    XmlRole { name: "username";     query: "username/string()" }
    XmlRole { name: "geolocation";  query: "location/string()" } // Property name can't be location. It prints the object location in memory
    XmlRole { name: "firstdatetaken"; query: "photos/firstdatetaken/string()" }
    //XmlRole { name: "views";        query: "photos/views/string()" }
    XmlRole { name: "count";        query: "photos/count/string()" }
}
