pragma ComponentBehavior: Bound
import QtQuick
import qs.components
import qs.singletons

Item {
    id: root

    width: content.width
    height: parent.height

    required property var window

    Rectangle {
        id: rect

        width: content.width
        height: parent.height
        topRightRadius: Global.defaultRadius
        bottomRightRadius: Global.defaultRadius
        color: Colors.surface
        anchors.centerIn: parent
    }

    Item {
        id: content

        anchors.centerIn: parent
        width: row.width + Global.defaultRadius
        height: parent.height

        Row {
            id: row

            anchors.centerIn: parent
            spacing: 2

            Tray {
                window: root.window
            }

            Caffeine {}

            Sound {
                anchors.verticalCenter: parent.verticalCenter
            }

            Battery {
                anchors.verticalCenter: parent.verticalCenter
            }

            Power {
                id: power

                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
