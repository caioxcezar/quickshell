pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.singletons

Item {
    id: root

    width: widget.width
    height: widget.height

    Rectangle {
        id: widget
        property bool actionPanel: false
        property bool actionNotification: false
        property bool actionMusic: false

        state: "Collapsed"
        color: Colors.surface
        height: Global.height
        radius: Global.defaultRadius
        states: [
            State {
                name: "ExpandedPanel"

                PropertyChanges {
                    target: widget
                    width: Panel.modal?.implicitWidth
                    bottomRightRadius: 0
                    bottomLeftRadius: 0
                    actionPanel: true
                    actionNotification: false
                    actionMusic: false
                }
            },
            State {
                name: "ExpandedNotification"

                PropertyChanges {
                    target: widget
                    width: Notification.modal?.implicitWidth
                    bottomRightRadius: 0
                    bottomLeftRadius: 0
                    actionPanel: false
                    actionNotification: true
                    actionMusic: false
                }
            },
            State {
                name: "ExpandedMusic"

                PropertyChanges {
                    target: widget
                    width: Notification.modal?.implicitWidth
                    bottomRightRadius: 0
                    bottomLeftRadius: 0
                    actionPanel: false
                    actionNotification: false
                    actionMusic: true
                }
            },
            State {
                name: "Collapsed"

                PropertyChanges {
                    target: widget
                    width: 300
                    bottomRightRadius: Global.defaultRadius
                    bottomLeftRadius: Global.defaultRadius
                    actionPanel: false
                    actionNotification: false
                    actionMusic: false
                }
            }
        ]

        transitions: Transition {
            onRunningChanged: {
                if (running || widget.state == "Collapsed")
                    return;

                if (widget.actionPanel)
                    Panel.openPanel();

                if (widget.actionNotification) {
                    Notification.openPanel(false);
                }

                if (widget.actionMusic)
                    MusicPlayer.openPanel();
            }

            PropertyAnimation {
                properties: "width,bottomRightRadius,bottomLeftRadius"
                duration: Global.animationSpeed / 2
                easing.type: Easing.OutCubic
            }
        }
    }

    RowLayout {
        id: content
        height: parent.height
        width: widget.width - 10
        anchors.centerIn: parent
        spacing: 5

        Item {

            width: Global.iconContainer
            height: Global.iconContainer

            IconColored {
                id: music
                source: Global.getIcon(Mpris.isPlaying ? "media-playback-pause-symbolic" : "media-playback-start-symbolic")
                iconColor: Colors.font
                Layout.alignment: Qt.AlignLeft
                anchors.centerIn: parent
                width: Global.iconSize
                height: Global.iconSize

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: {
                        if (MusicPlayer.isOpen) {
                            MusicPlayer.closePanel();
                            return;
                        }
                        if (Notification.isOpen) {
                            Notification.closePanel();
                        }
                        if (Panel.isOpen) {
                            Panel.closePanel();
                        }

                        widget.actionMusic = true;
                        widget.state = "ExpandedMusic";
                    }
                }
            }
        }

        RowLayout {
            spacing: 15
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Text {
                Layout.alignment: Qt.AlignVCenter
                color: Colors.font
                text: Time.time
                font.pointSize: Global.fontSize
            }

            Item {
                id: weather
                property var current: Weather.current ?? new Object()
                property var units: Weather.currentUnits ?? new Object()

                width: Global.iconContainer
                height: Global.iconContainer
                Layout.alignment: Qt.AlignVCenter

                Icon {
                    id: weatherIcon
                    anchors.centerIn: parent
                    source: Global.getIcon(weather.current.icon ?? "")
                    width: 48
                    height: 48
                }

                Text {
                    anchors.centerIn: parent
                    text: `${weather.current.temperature || ""}${weather.units.temperature || ""}`
                    color: Colors.font
                    style: Text.Outline

                    font.pointSize: Global.fontSize
                }
                visible: weatherIcon.status === Image.Ready
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: () => {
                    if (Panel.isOpen) {
                        Panel.closePanel();
                        return;
                    }
                    if (Notification.isOpen) {
                        Notification.closePanel();
                    }
                    if (MusicPlayer.isOpen) {
                        MusicPlayer.closePanel();
                    }

                    widget.state = "ExpandedPanel";
                }
            }
        }

        Item {
            width: Global.iconContainer
            height: Global.iconContainer
            Layout.alignment: Qt.AlignRight

            IconColored {
                id: notif
                source: Global.getIcon(Notifications.isMuted ? "notifications-disabled-symbolic" : "notifications-symbolic")
                iconColor: Colors.font
                anchors.centerIn: parent
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: {
                    Notifications.isMuted = !Notifications.isMuted;
                }
            }
        }
    }

    Connections {
        function onNotificationReceived(notif) {
            Notification.message = notif;
            if (Panel.isOpen || MusicPlayer.isOpen)
                return;

            if (widget.state == "Collapsed")
                widget.state = "ExpandedNotification";

            Notification.delay(3000, () => {
                Notification.closePanel();
            });
        }

        target: Notifications
    }

    Connections {
        function onAnimationFinished(isOpen) {
            if (!isOpen)
                widget.state = "Collapsed";
        }

        target: Panel
    }

    Connections {
        function onAnimationFinished(isOpen) {
            if (!isOpen && !widget.actionPanel && !widget.actionMusic)
                widget.state = "Collapsed";
        }

        target: Notification
    }

    Connections {
        function onAnimationFinished(isOpen) {
            if (!isOpen && !widget.actionPanel && !widget.actionNotification)
                widget.state = "Collapsed";
        }

        target: MusicPlayer
    }
}
