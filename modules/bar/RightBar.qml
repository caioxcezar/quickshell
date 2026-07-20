pragma ComponentBehavior: Bound
import QtQuick
import qs.components

Item {
    id: root

    height: parent.height
    width: row.width + 6

    required property var window
    property var colors: window.colors

    Row {
        id: row

        anchors.centerIn: parent
        spacing: 6

        Tray {
            window: root.window
        }

        Caffeine {
            iconColor: root.colors.font
        }

        Sound {
            iconColor: root.colors.font
            anchors.verticalCenter: parent.verticalCenter
        }

        Battery {
            iconColor: root.colors.font
            anchors.verticalCenter: parent.verticalCenter
        }

        Power {
            id: power
            iconColor: root.colors.font
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
