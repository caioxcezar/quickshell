pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.singletons

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    property bool contentActive: false
    property int animationSpeed: Global.animationSpeed / 2

    WlrLayershell.namespace: "quickshell:panel"
    anchors.top: true
    visible: false
    exclusiveZone: -1
    implicitWidth: 612
    implicitHeight: 0
    color: "transparent"
    // qmllint disable unqualified unresolved-type missing-property
    margins.top: Global.height + Global.marginBar
    // qmllint enable unqualified unresolved-type missing-property
    Component.onCompleted: {
        Panel.modal = root;
        Panel.animation = animation;
    }

    NumberAnimation {
        id: animation

        onStopped: {
            if (Panel.isOpen)
                root.contentActive = true;

            if (!root.implicitHeight)
                root.visible = false;

            Panel.animationFinished(Panel.isOpen);
        }
        onStarted: {
            if (!Panel.isOpen)
                root.contentActive = false;
        }
        target: root
        property: "implicitHeight"
        duration: root.animationSpeed
        easing.type: Easing.OutCubic
    }

    Rectangle {
        id: contentRect

        anchors.fill: parent
        color: Colors.background
        bottomRightRadius: Global.defaultRadius
        bottomLeftRadius: Global.defaultRadius

        Loader {
            active: root.contentActive
            anchors.fill: parent
            sourceComponent: RowLayout {
                anchors.fill: parent
                spacing: 5

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 5

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true

                            Rectangle {
                                anchors.fill: parent
                                radius: Global.defaultRadius
                                color: Colors.surface
                                clip: true
                                anchors.topMargin: 5
                                anchors.leftMargin: 5

                                CalendarView {
                                    anchors.margins: 5
                                    anchors.fill: parent
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: weatherView.implicitHeight + 15
                            Rectangle {
                                anchors.fill: parent
                                radius: Global.defaultRadius
                                color: Colors.surface
                                clip: true
                                anchors.bottomMargin: 5
                                anchors.leftMargin: 5

                                WeatherView {
                                    id: weatherView
                                    anchors.margins: 5
                                    anchors.fill: parent
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    NotificationsList {
                        anchors.fill: parent
                        anchors.topMargin: 5
                        anchors.bottomMargin: 5
                        anchors.rightMargin: 5
                        clip: true
                    }
                }
            }
        }
    }
}
