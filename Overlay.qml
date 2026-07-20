import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.singletons
import qs.modules.overlay

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    visible: Panel.isOpen || MusicPlayer.isOpen || Pipewire.isOpen || Notification.isOpen || Global.volumeContextVisibility || Global.brightnessContextVisibility
    property int animationSpeed: Global.animationSpeed / 2

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }

    color: "transparent"
    WlrLayershell.namespace: "quickshell:overlay"
    WlrLayershell.keyboardFocus: Panel.isOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    property var colors: Colors.getColorsByScreen(root.screen.name)

    PanelView {
        id: panel
        animationSpeed: root.animationSpeed
        colors: root.colors
    }

    MusicPlayerView {
        id: musicPlayer
        animationSpeed: root.animationSpeed
        colors: root.colors
    }

    SoundView {
        id: sound
        animationSpeed: root.animationSpeed
        colors: root.colors
    }

    NotificationView {
        id: notification
        animationSpeed: root.animationSpeed
        colors: root.colors
    }

    ContextView {
        id: context
        animationSpeed: root.animationSpeed
        colors: root.colors
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
    mask: Global.brightnessContextVisibility || Global.volumeContextVisibility || Notification.isOpen ? region : null
}
