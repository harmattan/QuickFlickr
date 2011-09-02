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

XmlListModel{    
    query: "/rsp/photo"
    XmlRole { name: "isfavorite";   query: "@isfavorite/number()" }
    XmlRole { name: "ispro";        query: "@ispro/number()" }
    XmlRole { name: "id";           query: "@id/string()" }
    XmlRole { name: "server";       query: "@server/string()" }
    XmlRole { name: "secret";       query: "@secret/string()" }
    XmlRole { name: "farm";         query: "@farm/string()" }
    XmlRole { name: "iconserver";   query: "@iconserver/string()" }
    XmlRole { name: "iconfarm";     query: "@iconfarm/string()" }
    //XmlRole { name: "realname";     query: "owner/@realname/string()" }
    XmlRole { name: "username";     query: "owner/@username/string()" }
    XmlRole { name: "geolocation";  query: "owner/@location/string()" } // Property name can't be location. It prints the object location in memory
    XmlRole { name: "datetaken";    query: "dates/@taken/string()" }
    XmlRole { name: "views";        query: "@views/string()" }
    XmlRole { name: "title";        query: "title/string()" }
    XmlRole { name: "description";  query: "description/string()" }
    XmlRole { name: "comments";     query: "comments/string()" }
    XmlRole { name: "tags";         query: "tags/string()" }
    XmlRole { name: "cancomment";   query: "editability/@cancomment/number()" }
}
