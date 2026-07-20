pragma ComponentBehavior: Bound
import QtQuick
import qs.components
import qs.singletons

// qmllint disable uncreatable-type
Item {
    id: root

    property int contentOpacity: 0
    required property int animationSpeed
    required property var colors

    visible: false
    implicitWidth: 300
    implicitHeight: 0
    anchors.horizontalCenter: parent.horizontalCenter

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
            color: root.colors.background
            bottomRightRadius: Global.defaultRadius
            bottomLeftRadius: Global.defaultRadius

            PlayerList {
                colors: root.colors
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
