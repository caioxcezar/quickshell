pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import qs.singletons

Item {
    id: root
    anchors.centerIn: parent
    width: row.width
    height: parent.height

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Styles.margin

        Repeater {
            model: 10

            Item {
                id: wsItem

                required property int index

                width: Styles.iconContainer
                height: Styles.iconContainer
                property int idx: index + 1

                property var ws: Hypr.workspaces.find(w => w.id === idx)
                property bool isActive: Boolean(ws?.focused)
                opacity: isActive ? 1 : 0.5

                Behavior on opacity {
                    NumberAnimation {
                        duration: Styles.animationSpeed
                    }
                }

                property bool isUrgent: Boolean(ws?.urgent)

                Text {
                    text: wsItem.isActive ? `\uf444` : `\uf4c3`
                    anchors.centerIn: parent
                    color: Colors.primaryText
                    font.pointSize: Styles.fontSize
                }

                TapHandler {
                    onTapped: Hypr.goToWorspace(wsItem.idx)
                }
            }
        }
    }
}
