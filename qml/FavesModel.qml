import QtQuick 1.0

XmlListModel{
    query: "/rsp/photo/person"
    XmlRole { name: "nsid"; query: "@nsid/string()" }
    XmlRole { name: "username"; query: "@username/string()" }
    XmlRole { name: "favedate"; query: "@favedate/string()" }
}

