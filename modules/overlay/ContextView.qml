pragma ComponentBehavior: Bound
import QtQuick
import qs.components
import qs.singletons

Item {
    id: root

    required property int animationSpeed
    required property var colors

    property var output: Pipewire.output
    property real volume: output?.audio.volume ?? 0
    property var brightness: Brightness.percentage

    visible: Global.volumeContextVisibility || Global.brightnessContextVisibility

    function delay(ms, callback) {
        delayTimer.interval = ms;
        delayTimer.triggered.connect(callback);
        delayTimer.start();
    }

    Connections {
        function onVolumeChanged() {
            if (Pipewire.isOpen)
                return;
            Global.volumeContextVisibility = true;
            delayTimer.stop();
            root.delay(1500, () => {
                Global.volumeContextVisibility = false;
            });
        }

        function onBrightnessChanged() {
            if (Pipewire.isOpen)
                return;
            Global.brightnessContextVisibility = true;
            delayTimer.stop();
            root.delay(1500, () => {
                Global.brightnessContextVisibility = false;
            });
        }

        target: root
    }

    implicitHeight: 50
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 150

    Loader {
        active: Global.volumeContextVisibility
        anchors.fill: parent

        sourceComponent: Item {
            anchors {
                fill: parent
                centerIn: parent
            }

            PercentageView {
                animationSpeed: root.animationSpeed
                percentage: root.volume
                icon: Pipewire.icon
                colors: root.colors
            }
        }
    }

    Loader {
        active: Global.brightnessContextVisibility && Brightness.max > 0
        anchors.fill: parent

        sourceComponent: Item {
            anchors {
                fill: parent
                centerIn: parent
            }

            PercentageView {
                animationSpeed: root.animationSpeed
                percentage: root.brightness / 100
                icon: Brightness.icon
                colors: root.colors
            }
        }
    }

    Timer {
        id: delayTimer

        repeat: false
        onTriggered: triggered.disconnect(triggered)
    }
}
