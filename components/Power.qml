import QtQuick
import Quickshell
import qs.components
import qs.singletons

Item {
    width: Global.iconContainer
    height: Global.iconContainer

    IconColored {
        source: Global.getIcon("system-shutdown-symbolic")
        iconColor: Colors.font
        anchors.centerIn: parent
        width: Global.iconSize
        height: Global.iconSize
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: {
            Global.powerVisibility = !Global.powerVisibility;
        }
    }
}
