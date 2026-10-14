pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property bool isOpen: false
    property var modal
    property var animation

    signal animationFinished(var isOpen)
}