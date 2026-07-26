pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.components
import qs.singletons

Item {
    id: root

    width: widget.width
    height: widget.height

    required property var window

    Item {
        id: widget
        property bool actionPanel: false
        property bool actionNotification: false
        property bool actionMusic: false

        state: "Collapsed"
        height: Styles.height
        states: [
            State {
                name: "ExpandedPanel"

                PropertyChanges {
                    target: widget
                    width: Panel.modal?.implicitWidth
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
                duration: Styles.animationSpeed / 2
                easing.type: Easing.OutCubic
            }
        }
    }

    RowLayout {
        id: content
        height: parent.height
        width: widget.width
        anchors.centerIn: parent
        spacing: Styles.margin

        Item {

            width: Styles.iconContainer
            height: Styles.iconContainer

            IconRounded {
                id: music
                iconSource: Global.getIcon(Mpris.isPlaying ? "media-playback-pause" : "media-playback-start")
                iconColor: Colors.primaryText
                background: Colors.primary
                Layout.alignment: Qt.AlignLeft
                anchors.centerIn: parent
                width: Styles.iconContainer
                height: Styles.iconContainer

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
            spacing: Styles.margin
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Text {
                Layout.alignment: Qt.AlignVCenter
                color: Colors.primaryText
                text: Time.time
                font.pointSize: Styles.fontSize
            }

            WeatherIcon {}

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
            width: Styles.iconContainer
            height: Styles.iconContainer
            Layout.alignment: Qt.AlignRight

            IconRounded {
                id: notif
                iconSource: Global.getIcon(Notifications.isMuted ? "notifications-disabled" : "notifications")
                background: Colors.primary
                iconColor: Colors.primaryText
                width: Styles.iconSize
                height: Styles.iconSize
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
