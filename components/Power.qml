import QtQuick
import qs.components
import qs.singletons

Item {
    id: root

    required property var iconColor

    width: Styles.iconContainer
    height: Styles.iconContainer

    Icon {
        source: Global.getIcon("system-shutdown")
        anchors.centerIn: parent
        width: Styles.iconSize
        height: Styles.iconSize
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: {
            AppState.powerVisibility = !AppState.powerVisibility;
        }
    }
}
