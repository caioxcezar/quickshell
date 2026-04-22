pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root
    readonly property var output: Pipewire.defaultAudioSink
    readonly property var input: Pipewire.defaultAudioSource
    readonly property string icon: {
        const audio = output?.audio || {};
        if (audio.muted)
            return Quickshell.iconPath("audio-volume-muted-symbolic");

        if (audio.volume < 0.34)
            return Quickshell.iconPath("audio-volume-low-symbolic");

        if (audio.volume < 0.64)
            return Quickshell.iconPath("audio-volume-medium-symbolic");

        return Quickshell.iconPath("audio-volume-high-symbolic");
    }

    PwObjectTracker {
        objects: [root.output, root.input]
    }
}
