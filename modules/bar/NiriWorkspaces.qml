pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Widgets
import qs.singletons

Item {
    id: root
    width: content.width
    height: parent.height

    required property var screen
    required property var colors

    property real activeX: 0
    property real activeY: 0
    property real activeWidth: 0
    property real activeHeight: 0

    Rectangle {
        id: rectangle
        width: content.width
        height: parent.height
        anchors.centerIn: parent
        color: root.colors.surface
        topLeftRadius: Global.defaultRadius
        bottomLeftRadius: Global.defaultRadius
        Rectangle {
            radius: Global.defaultRadius
            x: root.activeX
            y: root.activeY
            width: root.activeWidth
            height: root.activeHeight
            color: root.colors.primary

            Behavior on x {
                NumberAnimation {
                    duration: Global.animationSpeed
                }
            }
        }
    }

    Item {
        id: content
        anchors.centerIn: parent
        width: row.width + Global.defaultRadius
        height: parent.height

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 5

            Repeater {
                model: Niri.workspaces.filter(ws => ws.output === root.screen.name)

                Item {
                    id: wsItem

                    required property var modelData

                    width: Math.max(Global.iconContainer, icons.width + Global.defaultRadius)
                    height: Global.iconContainer
                    property int idx: modelData.idx

                    property bool isActive: modelData.is_focused
                    property var toplevels: {
                        // const toplevels = modelData.toplevels ?? [];``
                        // const map = new Map();
                        // for (const toplevel of toplevels) {
                        //     if (!map.has(toplevel.pid)) {
                        //         map.set(toplevel.pid, toplevel);
                        //     }
                        // }
                        // return Array.from(map.values());
                        return modelData.toplevels;
                    }

                    onIsActiveChanged: {
                        if (isActive)
                            root.updateActive(wsItem, highlight);
                    }

                    Component.onCompleted: {
                        if (!isActive)
                            root.updateActive(wsItem, highlight);
                    }

                    Rectangle {
                        id: highlight
                        anchors.centerIn: parent
                        width: Math.max(Global.iconContainer, icons.width + 10)
                        height: Global.iconContainer
                        radius: 10
                        color: {
                            if (wsItem.isActive)
                                return "transparent";
                            if (wsItem.modelData["is_urgent"])
                                return "#a83232";
                            return "transparent";
                        }

                        onWidthChanged: {
                            if (!wsItem.isActive)
                                return;
                            Qt.callLater(() => root.updateActive(wsItem, highlight));
                        }
                    }

                    Text {
                        visible: !wsItem.toplevels.length
                        text: wsItem.idx
                        font.bold: wsItem.isActive
                        anchors.centerIn: parent
                        color: wsItem.isActive ? root.colors.surface : root.colors.font
                        font.pointSize: Global.fontSize
                    }

                    Row {
                        id: icons
                        spacing: 1
                        anchors.centerIn: parent
                        Repeater {
                            model: wsItem.toplevels

                            IconImage {
                                required property var modelData

                                width: Global.iconSize
                                height: Global.iconSize

                                source: Global.getIcon(modelData.app_id ?? "", "image-missing")
                            }
                        }
                    }

                    TapHandler {
                        onTapped: Niri.goToWorspace(wsItem.idx)
                    }
                }
            }
        }
    }

    function updateActive(item, rect) {
        var mapped = item.mapToItem(rectangle, rect.x, rect.y);
        activeX = mapped.x;
        activeY = mapped.y;
        activeWidth = rect.width;
        activeHeight = rect.height;
    }
}
