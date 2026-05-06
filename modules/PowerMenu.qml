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

            visible: Global.powerVisibility
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

                    IconRounded {
                        id: icon
                        required property var modelData

                        iconSource: Quickshell.iconPath(modelData.icon)
                        iconColor: Colors.font
                        iconSize: 96
                        width: 128
                        height: 128
                        radius: 64

                        TapHandler {
                            acceptedButtons: Qt.LeftButton
                            onTapped: {
                                process.running = true;
                            }
                        }

                        Process {
                            id: process

                            running: false
                            command: icon.modelData.command
                        }
                    }
                }
            }
        }
    }
}
