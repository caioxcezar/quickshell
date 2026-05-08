pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    readonly property var workspaces: Hyprland.workspaces.values

    function goToWorspace(id) {
        Hyprland.dispatch("workspace " + id);
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
