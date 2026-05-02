pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.singletons

Item {
    id: root
    width: content.width
    height: parent.height

    property real activeX: 0
    property real activeY: 0
    property real activeWidth: 0
    property real activeHeight: 0

    Rectangle {
        id: rectangle
        width: content.width
        height: parent.height
        anchors.centerIn: parent
        color: Colors.surface
        topLeftRadius: Global.defaultRadius
        bottomLeftRadius: Global.defaultRadius
        Rectangle {
            radius: Global.defaultRadius
            x: root.activeX
            y: root.activeY
            width: root.activeWidth
            height: root.activeHeight
            color: Colors.primary

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
                model: 10

                Item {
                    id: wsItem

                    required property int index

                    width: Math.max(Global.iconContainer, icons.width + Global.defaultRadius)
                    height: Global.iconContainer
                    property int idx: index + 1

                    property var ws: Hypr.workspaces.find(w => w.id === idx)
                    property bool isActive: Hypr.focusedWorkspace?.id === idx
                    property var toplevels: {
                        const toplevels = ws?.toplevels?.values ?? [];
                        const map = new Map();
                        for (const toplevel of toplevels) {
                            if (!map.has(toplevel.lastIpcObject.pid)) {
                                map.set(toplevel.lastIpcObject.pid, toplevel);
                            }
                        }
                        return Array.from(map.values());
                    }

                    onIsActiveChanged: {
                        if (isActive)
                            Qt.callLater(() => root.updateActive(wsItem, highlight));
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
                            if (wsItem.ws?.urgent)
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
                        color: wsItem.isActive ? Colors.surface : Colors.font
                        font.pointSize: Global.fontSize
                    }

                    Loader {
                        id: icons
                        active: Boolean(wsItem.ws)
                        anchors.centerIn: parent

                        sourceComponent: Row {
                            spacing: 1
                            Repeater {
                                model: wsItem.toplevels

                                IconImage {
                                    required property var modelData

                                    width: Global.iconSize
                                    height: Global.iconSize

                                    source: Quickshell.iconPath(modelData.lastIpcObject?.class ?? "", "image-missing")
                                }
                            }
                        }
                    }

                    TapHandler {
                        onTapped: Hypr.goToWorspace(wsItem.idx)
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
