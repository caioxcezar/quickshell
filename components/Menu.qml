import QtQuick
import Quickshell.Io
import qs.components
import qs.singletons

Item {
    width: Styles.iconContainer
    height: Styles.iconContainer
    anchors.verticalCenter: parent.verticalCenter

    Icon {
        source: Global.getIcon("distributor-logo-archlinux", "application-menu")
        anchors.centerIn: parent
        width: Styles.iconSize
        height: Styles.iconSize
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: {
            process.running = true;
        }
    }

    Process {
        id: process

        running: false
        command: ["albert", "toggle"]
    }
}
