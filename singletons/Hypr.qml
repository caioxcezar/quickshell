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
            }
            if (["moveworkspace", "destroyworkspace"].includes(event.name)) {
                Hyprland.refreshWorkspaces();
            }
            if (["movewindow", "openwindow", "closewindow"].includes(event.name)) {
                Hyprland.refreshToplevels();
            }
        }

        target: Hyprland
    }
}
