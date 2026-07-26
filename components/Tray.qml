pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.singletons

Rectangle {
    id: root

    property var window

    width: outerRow.width + Styles.horizontalMargin
    height: Styles.height

    color: Colors.secondary
    radius: Styles.defaultRadius

    Row {
        id: outerRow

        spacing: Styles.margin
        anchors.centerIn: parent

        Repeater {
            model: SystemTray.items

            Item {
                id: item
                required property var modelData

                implicitWidth: Styles.iconSize
                implicitHeight: Styles.iconSize

                Image {
                    anchors.fill: parent
                    source: item.modelData.icon
                    width: Styles.iconSize
                    height: Styles.iconSize
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
                    acceptedButtons: Qt.MiddleButton
                    onTapped: () => {
                        if (Idle.isLocked)
                            return;
                        item.modelData.secondaryActivate();
                    }
                }

                TapHandler {
                    acceptedButtons: Qt.RightButton
                    onTapped: event => {
                        if (Idle.isLocked)
                            return;
                        const pos = item.mapToItem(root.window.contentItem, event.position.x, event.position.y);
                        item.modelData.hasMenu && item.modelData.display(root.window, pos.x, pos.y);
                    }
                }
            }
        }
    }
}
