import QtQuick
import qs.components
import qs.singletons

Item {
    id: root
    width: Styles.iconContainer
    height: parent.height
    required property var iconColor

    IconColored {
        source: Global.getIcon(Idle.onCaffeine ? "caffeine-cup-full" : "caffeine-cup-empty")
        iconColor: root.iconColor
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
