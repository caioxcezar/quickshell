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

        command: ["sh", "-c", `
            brightnessctl --version >/dev/null 2>&1 &&
            brightnessctl max`]

        running: true

        stdout: StdioCollector {
            onStreamFinished: root.getText(this.text, text => root.max = Number(text))
        }
    }

    Process {
        id: processSetBrightness

        command: ["sh", "-c", `
            brightnessctl --version >/dev/null 2>&1 &&
            brightnessctl set ${root.percentage}%`]

        stdout: StdioCollector {
            onStreamFinished: root.getText(this.text, text => root.percentage = Number(text))
        }
    }

    Process {
        id: processGetBrightness

        command: ["sh", "-c", `
            brightnessctl --version >/dev/null 2>&1 && sleep 0.1 &&
            brightnessctl get`]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.getText(this.text, text => root.percentage = root.getPercentage(text))
        }
    }

    Process {
        id: processSetIdleBrightness

        command: ["sh", "-c", `
            brightnessctl --version >/dev/null 2>&1 &&
            brightnessctl get &&
            brightnessctl set ${root.percentage}% >/dev/null 2>&1 &&
            brightnessctl get`]

        stdout: StdioCollector {
            onStreamFinished: root.getText(this.text, text => {
                const [before, after] = this.text.split('\n');
                root._idleBkpValue = Number(before);
                root.percentage = getPercentage(after);
            })
        }
    }

    function getPercentage(value) {
        return parseInt((Number(value) / root.max) * 100);
    }

    function getText(text, callback) {
        const value = (text || '').trim();
        if (!text)
            return;
        callback(value);
    }
}
