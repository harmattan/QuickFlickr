import QtQuick 1.0

XmlListModel{
    query: "/rsp/photos/photo"
    XmlRole { name: "owner"; query: "@owner/string()" }
    XmlRole { name: "title"; query: "@title/string()" }
    XmlRole { name: "url_s"; query: "@url_s/string()" }
    XmlRole { name: "ownername"; query: "@ownername/string()" }
    XmlRole { name: "photoid"; query: "@id/string()" }
    XmlRole { name: "media"; query: "@media/string()" }
    XmlRole { name: "media_status"; query: "@media_status/string()" }
    XmlRole { name: "latitude"; query: "@latitude/string()" }
    XmlRole { name: "longitude"; query: "@longitude/string()" }
}
