import QtQuick
import Quickshell
pragma Singleton

Singleton {
    property bool isOpen: false
    property var modal
    property var animation

    signal animationFinished(var isOpen)

    function openPanel() {
        modal.visible = true;
        animation.from = 0;
        animation.to = 200;
        isOpen = true;
        animation.start();
    }

    function closePanel() {
        animation.from = 200;
        animation.to = 0;
        isOpen = false;
        animation.start();
    }

    function delay(ms, callback) {
        delayTimer.interval = ms;
        delayTimer.triggered.connect(callback);
        delayTimer.start();
    }

    Timer {
        id: delayTimer

        repeat: false
        onTriggered: triggered.disconnect(triggered)
    }

}
