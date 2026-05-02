pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.components
import qs.singletons

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    property int contentOpacity: 0
    property int animationSpeed: Global.animationSpeed / 2

    anchors.top: true
    visible: false
    exclusiveZone: -1
    implicitWidth: 300
    implicitHeight: 0
    color: "transparent"
    // qmllint disable unqualified unresolved-type missing-property
    margins.top: Global.height + Global.marginBar
    // qmllint enable unqualified unresolved-type missing-property

    Component.onCompleted: {
        MusicPlayer.modal = root;
        MusicPlayer.animation = animation;
    }

    NumberAnimation {
        id: animation

        onStopped: {
            if (MusicPlayer.isOpen)
                root.contentOpacity = 1;

            if (!root.implicitHeight)
                root.visible = false;

            MusicPlayer.animationFinished(MusicPlayer.isOpen);
        }
        onStarted: {
            if (!MusicPlayer.isOpen)
                root.contentOpacity = 0;
        }
        target: root
        property: "implicitHeight"
        duration: root.animationSpeed
        easing.type: Easing.OutCubic
    }

    Loader {
        active: root.visible
        anchors.fill: parent

        sourceComponent: Rectangle {
            anchors.fill: parent
            color: Colors.background
            bottomRightRadius: Global.defaultRadius
            bottomLeftRadius: Global.defaultRadius

            PlayerList {
                opacity: root.contentOpacity

                header: Rectangle {
                    height: 5
                }

                footer: Rectangle {
                    height: 5
                }
            }
        }
    }
}
