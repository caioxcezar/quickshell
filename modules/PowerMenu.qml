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

            visible: Global.powerVisibility && !Idle.isLocked
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
                    Global.powerVisibility = false;
                }
            }

            Row {
                spacing: 64
                anchors.centerIn: parent

                Repeater {
                    model: Global.powerCommands.filter(cm => !cm.for || cm.for == Global.compositor)

                    Column {
                        id: item
                        required property var modelData
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: item.modelData.title
                            color: Colors.font
                            font.pointSize: Global.fontTitle
                            font.bold: true
                        }
                        Icon {
                            anchors.horizontalCenter: parent.horizontalCenter

                            source: Quickshell.iconPath(item.modelData.icon)
                            width: 96
                            height: 96

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
                    }
                }
            }
        }
    }
}
