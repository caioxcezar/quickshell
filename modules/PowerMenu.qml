pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.components
import qs.singletons

Scope {
    Variants {
        model: Quickshell.screens
        // qmllint disable uncreatable-type
        PanelWindow {
            id: root

            required property var modelData

            visible: AppState.powerVisibility && !Idle.isLocked
            color: Colors.background
            screen: modelData
            exclusiveZone: -1

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: {
                    AppState.powerVisibility = false;
                }
            }

            Row {
                id: row
                spacing: Styles.margin
                anchors.centerIn: parent

                Repeater {
                    model: Global.powerCommands.filter(cm => !cm.for || cm.for == AppState.compositor)

                    Rectangle {
                        id: item
                        required property var modelData

                        color: Colors.surface
                        width: 200
                        height: 200
                        radius: Styles.defaultRadius

                        Column {
                            anchors.fill: parent

                            Icon {
                                anchors.horizontalCenter: parent.horizontalCenter

                                source: Global.getIcon(item.modelData.icon)
                                width: 150
                                height: 150

                                TapHandler {
                                    acceptedButtons: Qt.LeftButton
                                    onTapped: {
                                        process.running = true;
                                    }
                                }

                                Process {
                                    id: process

                                    running: false
                                    command: item.modelData.command
                                }
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: item.modelData.title
                                color: Colors.primaryText
                                font.pointSize: Styles.fontTitle
                                font.bold: true
                            }
                        }
                    }
                }
            }
        }
    }
}
