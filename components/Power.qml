import QtQuick
import qs.components
import qs.singletons

Item {
    id: root

    required property var iconColor

    width: Global.iconContainer
    height: Global.iconContainer

    IconColored {
        source: Global.getIcon("system-shutdown-symbolic")
        iconColor: root.iconColor
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
