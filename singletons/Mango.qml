import Quickshell
import Quickshell.WindowManager
import Quickshell.Wayland
pragma Singleton
import Quickshell.Io

Singleton {
    readonly property var workspaces: WindowManager.windowsets
    readonly property var focusedWorkspace: WindowManager.windowsets.find((ws) => ws.active)
    readonly property var toplevels: ToplevelManager.toplevels.values

    function goToWorspace(id) {
        process.command = ["mmsg", "-s", "-t", id.toString()]
        process.running = true;
        
    }

    Process {
        id: process
    }
}