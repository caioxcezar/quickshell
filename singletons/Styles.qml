pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property int animationSpeed: 300
    readonly property int height: 24
    readonly property int iconSize: 22
    readonly property int iconContainer: 22
    readonly property int iconContainerRadius: iconContainer / 2
    readonly property real fontTitle: 20
    readonly property real fontSubtitle: 11
    readonly property real fontSize: 11
    readonly property real fontSmall: 8
    readonly property int margin: 6
    readonly property int horizontalMargin: margin * 2
    readonly property int defaultRadius: 12
}
