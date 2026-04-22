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
        animation.to = 350;
        isOpen = true;
        animation.start();
    }

    function closePanel() {
        animation.from = 350;
        animation.to = 0;
        isOpen = false;
        animation.start();
    }

}
