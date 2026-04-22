import QtQuick
import Quickshell
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

        Rectangle {
            width: tray.width
            height: Global.height
            color: "transparent"
            anchors {
                top: parent.top
                right: parent.right
                margins: 5
            }

            RightBar {
                id: tray
                window: root
                anchors.right: parent.right
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
