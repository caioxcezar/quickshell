pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property var workspaces: []
    property var _workspaces: new Object()
    property var _toplevels: new Object()
    property string socketPath: ""

    function goToWorspace(id) {
        niriAction.focusWorkspace(id);
    }

    Process {
        id: niriAction
        command: []

        function focusWorkspace(index) {
            niriAction.command = ["niri", "msg", "--json", "action", "focus-workspace", String(index)];
            niriAction.running = true;
        }
    }

    Process {
        running: true
        command: ["sh", "-c", "echo $NIRI_SOCKET"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.socketPath = this.text.trim();
                niriSocket.connected = true;
            }
        }
    }

    Socket {
        id: niriSocket
        path: root.socketPath
        connected: false

        onConnectionStateChanged: {
            if (this.connected)
                this.write('"EventStream"\n');
        }

        parser: SplitParser {
            onRead: data => {
                const line = data.toString().trim();
                // console.log(">>>", line);
                if (!line)
                    return;

                const json = JSON.parse(line);

                if (json.WorkspacesChanged) {
                    root._workspaces = new Object();
                    for (const ws of json.WorkspacesChanged.workspaces)
                        root._workspaces[ws.id] = ws;
                }
                if (json.WindowsChanged) {
                    root._toplevels = json.WindowsChanged.windows;
                }
                if (json.WorkspaceActivated) {
                    const {
                        id,
                        focused
                    } = json.WorkspaceActivated;
                    const focusedWs = root._workspaces[id];
                    for (const ws of Object.values(root._workspaces)) {
                        if (ws.output === focusedWs.output) {
                            ws.is_focused = false;
                        }
                    }
                    focusedWs.is_focused = focused;
                }
                if (json.WindowClosed) {
                    if (root._toplevels[json.WindowClosed.id]) {
                        delete root._toplevels[json.WindowClosed.id];
                    }
                }
                if (json.WindowOpenedOrChanged) {
                    const {
                        window
                    } = json.WindowOpenedOrChanged;
                    root._toplevels[window.id] = window;
                }

                root.workspaces = Object.values(root._workspaces).map(ws => {
                    ws.toplevels = Object.values(root._toplevels).filter(tl => ws.id === tl.workspace_id);
                    return ws;
                }).sort((a, b) => a.id - b.id);
            }
        }
    }
}
