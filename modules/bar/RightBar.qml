pragma ComponentBehavior: Bound
import QtQuick
import qs.components
import qs.singletons

Item {
    id: root

    height: parent.height
    width: row.width + 6

    required property var window

    Row {
        id: row

        anchors.centerIn: parent
        spacing: Styles.margin

        Tray {
            window: root.window
        }

        Caffeine {
            iconColor: Colors.primaryText
        }

        Sound {
            iconColor: Colors.primaryText
            anchors.verticalCenter: parent.verticalCenter
        }

        Battery {
            iconColor: Colors.primaryText
            anchors.verticalCenter: parent.verticalCenter
        }

        Power {
            id: power
            iconColor: Colors.primaryText
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
