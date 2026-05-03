pragma ComponentBehavior: Bound
import QtQuick
import qs.singletons

ListView {
    id: root

    spacing: 5
    model: [...Notifications.list.values].reverse()

    delegate: Rectangle {
        id: rect
        required property var modelData

        width: root.width
        height: content.implicitHeight + 16
        color: Colors.surface
        radius: Global.defaultRadius

        NotificationView {
            id: content

            notification: rect.modelData
        }
    }
}
