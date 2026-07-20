pragma ComponentBehavior: Bound
import QtQuick
import qs.singletons

ListView {
    id: root

    required property var colors

    spacing: 5
    model: [...Notifications.list.values].reverse()

    delegate: Rectangle {
        id: rect
        required property var modelData

        width: root.width
        height: content.implicitHeight + 16
        color: root.colors.surface
        radius: Global.defaultRadius

        NotificationView {
            id: content
            colors: root.colors
            notification: rect.modelData
        }
    }
}
