pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property bool dev: false
    readonly property int animationSpeed: 300
    readonly property int height: 40
    readonly property int iconSize: 16
    readonly property int iconContainer: 25
    readonly property int iconContainerRadius: iconContainer / 2
    readonly property real fontTitle: 20
    readonly property real fontSubtitle: 11
    readonly property real fontSize: 10
    readonly property real fontSmall: 8
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
