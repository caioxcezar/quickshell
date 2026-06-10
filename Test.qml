pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import qs.singletons
import qs.components
import qs.modules.bar

PanelWindow {
    id: root
    screen: Quickshell.screens[0]
    visible: true
    exclusiveZone: -1
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.background

        ColumnLayout {
            width: tray.width
            height: parent.height
            anchors {
                top: parent.top
                right: parent.right
                margins: 5
            }

            RightBar {
                id: tray
                window: root
                height: Global.height
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            }

            Column {
                id: powerMenu
                opacity: Global.powerVisibility && Idle.isLocked ? 1 : 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                Repeater {
                    width: parent.width
                    model: Global.powerCommands.filter(cm => !cm.for || cm.for == Global.compositor)

                    Column {
                        id: item
                        width: parent.width
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

                            source: Global.getIcon(item.modelData.icon)
                            width: 96
                            height: 96

                            TapHandler {
                                acceptedButtons: Qt.LeftButton
                                onTapped: {
                                    if (powerMenu.opacity)
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

                Behavior on opacity {
                    NumberAnimation {
                        duration: Global.animationSpeed
                    }
                }
            }
        }

        Rectangle {
            width: 500
            height: parent.height
            color: "transparent"
            anchors.bottom: parent.bottom

            PlayerList {
                verticalLayoutDirection: ListView.BottomToTop

                header: Item {
                    height: 5
                }
            }
        }

        Row {
            spacing: 64
            anchors.centerIn: parent

            Loader {
                readonly property Component loading: Loading {
                    animationSpeed: 200
                }

                readonly property Component input: Column {
                    anchors.centerIn: parent
                    spacing: 16

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: Time.time
                        color: Colors.font
                        font.pointSize: Global.fontTitle
                        font.bold: true
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Screen Locked"
                        color: Colors.font
                        font.pointSize: Global.fontTitle
                        font.bold: true
                    }

                    TextField {
                        id: passwordField

                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 300
                        height: 40
                        placeholderText: "Enter password..."
                        placeholderTextColor: Colors.font
                        echoMode: TextInput.Password
                        color: Colors.font

                        background: Rectangle {
                            color: Colors.surface
                            radius: 8
                        }
                    }
                }

                sourceComponent: input
            }
        }
    }
}
