pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.singletons

Item {
    id: root

    property var window

    width: outerRow.width + 5
    height: Global.height

    Row {
        id: outerRow

        spacing: 6
        anchors.centerIn: parent

        Repeater {
            model: SystemTray.items

            Item {
                id: item
                required property var modelData

                implicitWidth: 20
                implicitHeight: 20

                Image {
                    anchors.fill: parent
                    source: item.modelData.icon
                    width: Global.iconSize
                    height: Global.iconSize
                    sourceSize.width: width
                    sourceSize.height: height
                    layer.enabled: true
                }

                QsMenuAnchor {
                    id: menuAnchor

                    menu: item.modelData.menu
                    anchor.window: root.window
                    anchor.rect: Qt.rect(0, 0, item.parent.width, item.parent.height)
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: () => {
                        if (Idle.isLocked)
                            return;
                        item.modelData.activate();
                    }
                }

                TapHandler {
                    acceptedButtons: Qt.RightButton
                    onTapped: event => {
                        const pos = item.mapToItem(root.window.contentItem, event.position.x, event.position.y);
                        item.modelData.hasMenu && item.modelData.display(root.window, pos.x, pos.y);
                    }
                }
            }
        }
    }
}
