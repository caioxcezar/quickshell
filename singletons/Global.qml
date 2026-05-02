pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property string compositor: "hyprland"
    readonly property bool dev: false
    readonly property int animationSpeed: 300
    readonly property int height: 48
    readonly property int iconSize: 24
    readonly property int iconContainer: 28
    readonly property int iconContainerRadius: iconContainer / 2
    readonly property real fontTitle: 20
    readonly property real fontSubtitle: 11
    readonly property real fontSize: 11
    readonly property real fontSmall: 8
    readonly property int marginBar: 5
    readonly property int defaultRadius: 10
    property bool powerVisibility: false
    readonly property var powerCommands: [
        {
            "title": "Shutdown",
            "icon": "system-shutdown-symbolic",
            "command": ["systemctl", "poweroff"]
        },
        {
            "title": "Reboot",
            "icon": "system-reboot-symbolic",
            "command": ["systemctl", "reboot"]
        },
        {
            "title": "Log-out",
            "icon": "system-log-out-symbolic",
            "command": ["hyprctl", "dispatch", "exit"]
        }
    ]
}
