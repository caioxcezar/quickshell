pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property bool isOpen: false
    property var message: null
    property var modal
    property var animation

    signal animationFinished(var isOpen)

    function openPanel(interactable = true) {
        modal.visible = true;
        modal.interactable = interactable;
        animation.from = 0;
        animation.to = 70;
        isOpen = true;
        animation.start();
    }

    function closePanel() {
        animation.from = 70;
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
