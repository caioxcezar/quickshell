pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root
    readonly property var output: Pipewire.defaultAudioSink
    readonly property var input: Pipewire.defaultAudioSource
    readonly property var programs: Pipewire.nodes.values.filter(n => n.isSink && n.isStream && n.audio !== null && n !== Pipewire.defaultAudioSink)
    readonly property var outputs: Pipewire.nodes.values.filter(n => n.isSink && !n.isStream && n.audio !== null)

    readonly property string icon: getVolumeIcon(output?.audio?.volume || 0, output?.audio?.muted || false)

    property bool isOpen: false
    property var modal
    property var animation

    signal animationFinished(var isOpen)

    PwObjectTracker {
        objects: [root.output, root.input, ...root.programs]
    }

    function getVolumeIcon(volume, isMuted) {
        let icon = "";
        if (isMuted)
            icon = "audio-volume-muted-symbolic";
        else if (volume < 0.34)
            icon = "audio-volume-low-symbolic";
        else if (volume < 0.64)
            icon = "audio-volume-medium-symbolic";
        else
            icon = "audio-volume-high-symbolic";

        return Global.getIcon(icon);
    }

    function setOutput(node) {
        Pipewire.preferredDefaultAudioSink = node;
    }

    function openPanel() {
        modal.visible = true;
        animation.from = 0;
        animation.to = 350;
        isOpen = true;
        animation.start();
    }

    function closePanel() {
        animation.from = 350;
        animation.to = 0;
        isOpen = false;
        animation.start();
    }
}
