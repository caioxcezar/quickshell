import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.singletons
import qs.modules.overlay

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    visible: Panel.isOpen || MusicPlayer.isOpen || Pipewire.isOpen || Notification.isOpen || Global.contextVisibility
    property int animationSpeed: Global.animationSpeed / 2

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }

    color: "transparent"
    WlrLayershell.namespace: "quickshell:overlay"

    PanelView {
        id: panel
        animationSpeed: root.animationSpeed
    }

    MusicPlayerView {
        id: musicPlayer
        animationSpeed: root.animationSpeed
    }

    SoundView {
        id: sound
        animationSpeed: root.animationSpeed
    }

    NotificationView {
        id: notification
        animationSpeed: root.animationSpeed
    }

    ContextView {
        id: context
        animationSpeed: root.animationSpeed
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: {
            if (Panel.isOpen)
                Panel.closePanel();
            if (MusicPlayer.isOpen)
                MusicPlayer.closePanel();
            if (Pipewire.isOpen)
                Pipewire.closePanel();
        }
    }

    Region {
        id: region
    }
    mask: Global.contextVisibility || Notification.isOpen ? region : null
}
