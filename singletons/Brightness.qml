pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int percentage: 0
    property int _idleBkpPercentage: 0
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
        root.percentage = root._idleBkpPercentage;
        processSetBrightness.running = true;
    }

    Process {
        id: processSetBrightness

        command: ["brightnessctl", "set", `${root.percentage}%`]
    }

    Process {
        id: processSetIdleBrightness

        command: ["brightnessctl", "get"]

        stdout: StdioCollector {
            onStreamFinished: {
                root._idleBkpPercentage = Number(this.text);
                processSetBrightness.running = true;
            }
        }
    }
}
