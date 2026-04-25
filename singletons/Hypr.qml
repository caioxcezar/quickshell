import QtQuick
import Quickshell
import Quickshell.Hyprland
pragma Singleton

Singleton {
    readonly property var workspaces: Hyprland.workspaces.values
    readonly property var focusedWorkspace: Hyprland.focusedWorkspace

    function goToWorspace(id) {
        Hyprland.dispatch("workspace " + id);
    }

    Connections {
        function onRawEvent(event) {
            if (event.name === "openwindow") {
                Hyprland.refreshToplevels();
            }

        }

        target: Hyprland
    }

}
