import QtQuick
import Quickshell
import qs.components
import qs.singletons

Item {
    width: Global.iconContainer
    height: Global.iconContainer

    IconColored {
        source: Quickshell.iconPath("system-shutdown-symbolic")
        iconColor: Colors.surface
        anchors.centerIn: parent
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: {
            if (Idle.isLocked)
                return;
            Global.powerVisibility = true;
        }
    }
}
