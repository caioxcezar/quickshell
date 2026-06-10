import QtQuick
import Quickshell
import qs.components
import qs.singletons

Item {
    width: Global.iconContainer
    height: parent.height

    IconColored {
        source: Global.getIcon(Idle.onCaffeine ? "my-caffeine-on-symbolic" : "my-caffeine-off-symbolic")
        iconColor: Colors.font
        anchors.centerIn: parent
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: {
            if (Idle.isLocked)
                return;
            Idle.onCaffeine = !Idle.onCaffeine;
        }
    }
}
