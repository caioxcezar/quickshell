pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    readonly property var workspaces: Hyprland.workspaces.values

    function goToWorspace(id) {
        process.command = ["hyprctl", "dispatch", `hl.dsp.focus({ workspace = "${id}" })`];
        process.running = true;
    }

    Process {
        id: process

        running: false
        command: []
    }

    Connections {
        function onRawEvent(event) {
            switch (event.name) {
            case "monitorremoved":
            case "monitoradded":
                Hyprland.refreshMonitors();
                break;
            case "moveworkspace":
            case "destroyworkspace":
                Hyprland.refreshWorkspaces();
                break;
            case "movewindow":
            case "openwindow":
            case "closewindow":
                Hyprland.refreshToplevels();
                break;
            }
        }

        target: Hyprland
    }
}
