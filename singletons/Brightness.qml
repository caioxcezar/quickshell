pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    property int percentage: 0
    property int _idleBkpValue: 0
    property int max: 0

    function setBrightness(percentage) {
        root.percentage = percentage;
        processSetBrightness.running = true;
    }

    function setIdleBrightness(percentage) {
        root.percentage = percentage;
        processSetIdleBrightness.running = true;
    }

    function resetIdleBrightness() {
        root.percentage = root._idleBkpValue;
        processSetBrightness.running = true;
    }

    property var icon: {
        let icon = ["brightness"];

        if (percentage < 33)
            icon.push("low");
        else if (percentage < 66)
            icon.push("medium");
        else
            icon.push("high");

        icon.push("symbolic");

        return Global.getIcon(icon.join("-"));
    }

    // qmllint disable unresolved-type
    GlobalShortcut {
        name: "get-brightness"
        description: "Update the brightness"
        onPressed: {
            processGetBrightness.running = true;
        }
    }
    // qmllint enable unresolved-type

    Process {
        id: processGetMaxBrightness

        command: ["brightnessctl", "max"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.max = Number(this.text);
            }
        }
    }

    Process {
        id: processSetBrightness

        command: ["brightnessctl", "set", `${root.percentage}%`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.percentage = Number(this.text);
            }
        }
    }

    Process {
        id: processGetBrightness

        command: ["sh", "-c", "sleep 0.1 && brightnessctl get"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.percentage = parseInt((Number(this.text) / root.max) * 100);
            }
        }
    }

    Process {
        id: processSetIdleBrightness

        command: ["brightnessctl", "get"]

        stdout: StdioCollector {
            onStreamFinished: {
                root._idleBkpValue = Number(this.text);
                processSetBrightness.running = true;
            }
        }
    }
}
