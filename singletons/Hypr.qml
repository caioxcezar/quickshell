pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    readonly property var workspaces: Hyprland.workspaces.values
    readonly property var focusedWorkspace: Hyprland.focusedWorkspace

    function goToWorspace(id) {
        Hyprland.dispatch("workspace " + id);
    }

    Connections {
        function onRawEvent(event) {
            if (["monitorremoved", "monitoradded"].includes(event.name)) {
                Hyprland.refreshMonitors();
            } else if (["moveworkspace", "openwindow", "closewindow"].includes(event.name)) {
                Hyprland.refreshWorkspaces();
                Hyprland.refreshToplevels();
            }
        }

        target: Hyprland
    }
}
