pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.singletons
import qs.components

Item {
    id: root

    required property int animationSpeed
    required property var colors
    property bool contentActive: false
    visible: false

    implicitWidth: 612
    implicitHeight: 0
    anchors.horizontalCenter: parent.horizontalCenter

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
        color: root.colors.background
        anchors.fill: parent
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
                                color: root.colors.surface
                                clip: true
                                anchors.topMargin: 5
                                anchors.leftMargin: 5

                                CalendarView {
                                    anchors.margins: 5
                                    anchors.fill: parent

                                    colors: root.colors
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: weatherView.implicitHeight + 15
                            Rectangle {
                                anchors.fill: parent
                                radius: Global.defaultRadius
                                color: root.colors.surface
                                clip: true
                                anchors.bottomMargin: 5
                                anchors.leftMargin: 5

                                WeatherView {
                                    id: weatherView
                                    colors: root.colors
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
                        colors: root.colors

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
