pragma ComponentBehavior: Bound
import QtQuick
import qs.singletons

ListView {
    id: root

    clip: true
    spacing: 8
    model: [...Mpris.players].reverse()

    anchors.fill: parent

    delegate: Rectangle {
        id: item
        required property var modelData

        width: root.width - 10
        height: content.implicitHeight + 10
        color: Colors.surface
        radius: 6
        anchors.horizontalCenter: parent.horizontalCenter

        PlayerView {
            id: content
            anchors.centerIn: parent
            width: parent.width - 10
            music: item.modelData
        }
    }
}
