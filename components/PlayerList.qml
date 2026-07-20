pragma ComponentBehavior: Bound
import QtQuick
import qs.singletons

ListView {
    id: root

    required property var colors

    clip: true
    spacing: 8
    model: [...Mpris.players].reverse()

    anchors.fill: parent

    delegate: Rectangle {
        id: item
        required property var modelData

        width: root.width - 10
        height: content.implicitHeight + 10
        color: root.colors.surface
        radius: Global.defaultRadius
        anchors.horizontalCenter: parent.horizontalCenter

        PlayerView {
            id: content

            colors: root.colors

            anchors.centerIn: parent
            width: parent.width - 10
            music: item.modelData
        }
    }
}
