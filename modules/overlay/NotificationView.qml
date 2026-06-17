pragma ComponentBehavior: Bound
import QtQuick
import qs.components
import qs.singletons

Item {
    id: root

    required property int animationSpeed
    property int contentOpacity: 0
    property bool interactable: true

    visible: false
    implicitWidth: 300
    implicitHeight: 0
    anchors.horizontalCenter: parent.horizontalCenter

    Component.onCompleted: {
        Notification.modal = root;
        Notification.animation = animation;
    }

    NumberAnimation {
        id: animation

        onStopped: {
            if (Notification.isOpen)
                root.contentOpacity = 1;

            if (!root.implicitHeight) {
                progressAnimation.stop();
                progressBar.width = 0;
                Notification.message = null;
                root.visible = false;
            }
            Notification.animationFinished(Notification.isOpen);
        }
        onStarted: {
            if (Notification.isOpen)
                progressBar.showAnimated();
            else
                root.contentOpacity = 0;
        }
        target: root
        property: "implicitHeight"
        duration: root.animationSpeed
        easing.type: Easing.OutCubic
    }

    Rectangle {
        id: progressBar

        function showAnimated() {
            progressBar.width = root.implicitWidth;
            progressAnimation.duration = 3000;
            progressAnimation.start();
        }
        // qmllint disable missing-property
        anchors.top: root.top
        anchors.left: root.left
        // qmllint enable missing-property
        height: 2
        width: 0
        color: Colors.font

        NumberAnimation {
            id: progressAnimation

            target: progressBar
            property: "width"
            from: root.implicitWidth
            to: 0
            duration: 3000
            easing.type: Easing.Linear
        }
    }

    Loader {
        active: root.visible && Notification.message != null
        anchors.fill: parent

        sourceComponent: Rectangle {
            anchors.fill: parent
            clip: true
            color: Colors.background
            bottomRightRadius: 10
            bottomLeftRadius: 10

            NotificationView {
                id: notfiView

                opacity: root.contentOpacity
                notification: Notification.message
                interactable: root.interactable
                fontColor: Colors.surface

                Connections {
                    function onOpacityChanged() {
                        if (root.contentOpacity == 1)
                            root.implicitHeight = notfiView.height + 20;
                    }

                    target: notfiView
                }
            }
        }
    }
}
