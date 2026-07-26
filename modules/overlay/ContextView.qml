pragma ComponentBehavior: Bound
import QtQuick
import qs.components
import qs.singletons

Item {
    id: root

    required property int animationSpeed

    property var output: Pipewire.output
    property real volume: output?.audio.volume ?? 0
    property var brightness: Brightness.percentage

    visible: AppState.volumeContextVisibility || AppState.brightnessContextVisibility

    function delay(ms, callback) {
        delayTimer.interval = ms;
        delayTimer.triggered.connect(callback);
        delayTimer.start();
    }

    Connections {
        function onVolumeChanged() {
            if (Pipewire.isOpen)
                return;
            AppState.volumeContextVisibility = true;
            delayTimer.stop();
            root.delay(1500, () => {
                AppState.volumeContextVisibility = false;
            });
        }

        function onBrightnessChanged() {
            if (Pipewire.isOpen)
                return;
            AppState.brightnessContextVisibility = true;
            delayTimer.stop();
            root.delay(1500, () => {
                AppState.brightnessContextVisibility = false;
            });
        }

        target: root
    }

    implicitHeight: 50
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 150

    Loader {
        active: AppState.volumeContextVisibility
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
            }
        }
    }

    Loader {
        active: AppState.brightnessContextVisibility && Brightness.max > 0
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
            }
        }
    }

    Timer {
        id: delayTimer

        repeat: false
        onTriggered: triggered.disconnect(triggered)
    }
}
