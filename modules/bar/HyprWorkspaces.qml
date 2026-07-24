pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import qs.singletons

Item {
    id: root
    width: content.width
    height: parent.height

    required property var colors

    Item {
        id: content
        anchors.centerIn: parent
        width: row.width
        height: parent.height

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 6

            Repeater {
                model: 10

                Item {
                    id: wsItem

                    required property int index

                    width: Math.max(Global.iconContainer, icons.width)
                    height: Global.iconContainer
                    property int idx: index + 1

                    property var ws: Hypr.workspaces.find(w => w.id === idx)
                    property bool isActive: Boolean(ws?.focused)
                    opacity: isActive ? 1 : 0.5

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Global.animationSpeed
                        }
                    }

                    property bool isUrgent: Boolean(ws?.urgent)
                    property var toplevels: {
                        const map = new Set();
                        const toplevels = (ws?.toplevels?.values ?? []).filter(toplevel => {
                            const {
                                pid,
                                title
                            } = toplevel.lastIpcObject;
                            return !title || map.has(pid) ? false : map.add(pid);
                        });

                        return toplevels;
                    }

                    Text {
                        visible: !wsItem.toplevels.length
                        text: wsItem.idx
                        font.bold: wsItem.isActive
                        anchors.centerIn: parent
                        color: colors.font
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

                                    source: Global.getIcon(modelData.lastIpcObject?.class ?? "", "application-x-executable")

                                    layer.enabled: modelData.urgent
                                    layer.effect: ColorOverlay {
                                        color: '#c4ff6b6b'
                                    }
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
}
