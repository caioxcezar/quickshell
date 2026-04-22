pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.components
import qs.singletons

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    property var output: Pipewire.output
    property real volume: output?.audio.volume ?? 0

    function delay(ms, callback) {
        delayTimer.interval = ms;
        delayTimer.triggered.connect(callback);
        delayTimer.start();
    }

    Connections {
        function onVolumeChanged() {
            root.visible = true;
            delayTimer.stop();
            root.delay(1500, () => {
                root.visible = false;
            });
        }

        target: root
    }

    visible: false
    exclusiveZone: -1
    implicitHeight: 50
    // qmllint disable unqualified unresolved-type missing-property
    margins.bottom: 150
    // qmllint enable unqualified unresolved-type missing-property
    color: "transparent"

    anchors {
        bottom: true
        left: true
        right: true
    }

    Loader {
        active: root.visible
        anchors.fill: parent

        sourceComponent: Item {
            id: container
            anchors {
                fill: parent
                centerIn: parent
            }

            Rectangle {
                id: row

                color: Colors.background
                radius: 10

                width: 220
                height: parent.height
                anchors.centerIn: parent

                Row {
                    width: parent.width - 5
                    height: parent.height
                    spacing: 5

                    Item {
                        id: icon
                        height: parent.height
                        width: parent.height
                        anchors.verticalCenter: parent.verticalCenter

                        IconColored {

                            anchors.centerIn: parent
                            height: parent.height - 10
                            width: parent.height - 10
                            source: Pipewire.icon
                            iconColor: Colors.font
                        }
                    }

                    Item {
                        width: parent.width - icon.width - 5
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            text: `${(root.volume * 100).toFixed(0)}%`
                            color: Colors.font
                            font.pointSize: Global.fontSize
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                        }

                        Rectangle {
                            width: parent.width
                            color: "#888888"
                            height: 10
                            radius: 10
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                width: parent.width * root.volume
                                color: Colors.font
                                height: 10
                                radius: 10
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter

                                Behavior on width {
                                    NumberAnimation {
                                        duration: Global.animationSpeed / 2
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: delayTimer

        repeat: false
        onTriggered: triggered.disconnect(triggered)
    }

    mask: Region {}
}
