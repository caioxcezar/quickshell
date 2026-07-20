import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.singletons

Item {
    id: root
    required property var screen
    property var theme: "dark"

    anchors.fill: parent

    Item {
        id: cropArea
        anchors.fill: parent
        clip: true
        opacity: 0

        ScreencopyView {
            id: screencopy

            paintCursor: false
            captureSource: root.screen
            live: false
            x: 0
            y: 0
            width: root.screen.width
            height: root.screen.height
        }
    }

    ColorQuantizer {
        id: quantizer
        depth: 0
        rescaleSize: 32
    }

    Timer {
        id: grabDelay
        interval: 150
        onTriggered: {
            cropArea.grabToImage(result => {
                const path = `/tmp/qs-bar-sample-${screen.name}.png`;
                result.saveToFile(path);
                quantizer.source = `file://${path}`;
            });
        }
    }

    function sampleLuminance() {
        screencopy.captureFrame();
        grabDelay.restart();
    }

    Connections {
        target: quantizer
        function onColorsChanged() {
            if (quantizer.colors.length === 0)
                return;
            const c = quantizer.colors[0];
            const luminance = 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
            root.theme = luminance > 0.55 ? "light" : "dark";
            Colors.screens[root.screen.name] = root.theme;
            PreLoading.luminanceLoaded = true;
        }
    }

    Connections {
        function onLockscreenLoadedChanged() {
            if (PreLoading.lockscreenLoaded)
                sampleLuminance();
        }
        target: PreLoading
    }
}
