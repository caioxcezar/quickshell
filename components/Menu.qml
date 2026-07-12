import QtQuick
import Quickshell.Io
import qs.components
import qs.singletons

Item {
    width: Global.iconContainer
    height: Global.iconContainer
    anchors.verticalCenter: parent.verticalCenter

    Icon {
        source: Global.getIcon("distributor-logo-archlinux", "application-menu")
        anchors.centerIn: parent
        width: Global.iconSize
        height: Global.iconSize
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
