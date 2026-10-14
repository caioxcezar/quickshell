import QtQuick
import qs.singletons

Item {
    id: root

    property bool contentActive: false
    required property int animationSpeed

    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: Styles.margin

    Component.onCompleted: {
        LLMs.modal = root;
        LLMs.animation = animation;
    }

    NumberAnimation {
        id: animation

        onStopped: {
            if (LLMs.isOpen)
                root.contentActive = true;

            if (!root.implicitWidth)
                root.visible = false;

            LLMs.animationFinished(LLMs.isOpen);
        }
        onStarted: {
            if (!LLMs.isOpen)
                root.contentActive = false;
        }
        target: root
        property: "implicitWidth"
        duration: root.animationSpeed
        easing.type: Easing.OutCubic
    }
}