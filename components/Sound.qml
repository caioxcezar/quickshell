pragma ComponentBehavior: Bound
import QtQuick
import qs.components
import qs.singletons

Item {
    id: root

    required property var iconColor

    property var output: Pipewire.output
    property var input: Pipewire.input

    height: parent.height
    width: loader.width

    Loader {
        id: loader

        active: Boolean(root.output)
        anchors.centerIn: parent

        sourceComponent: Row {
            anchors.centerIn: parent
            spacing: 2

            WheelHandler {
                orientation: Qt.Vertical
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: e => {
                    if (Idle.isLocked)
                        return;
                    if (e.angleDelta.y > 0 && root.output.audio.volume >= 1)
                        return;
                    if (e.angleDelta.y < 0 && root.output.audio.volume <= 0)
                        return;

                    const change = e.angleDelta.y > 0 ? 0.01 : -0.01;

                    const volume = Number(root.output.audio.volume + change).toFixed(2);
                    root.output.audio.volume = volume;
                }
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onTapped: {
                    if (Pipewire.isOpen)
                        Pipewire.closePanel();
                    else
                        Pipewire.openPanel();
                }
            }

            IconColored {
                id: image

                anchors.verticalCenter: parent.verticalCenter
                source: Pipewire.icon
                iconColor: root.iconColor
            }

            Text {
                id: text

                text: `${(root.output.audio.volume * 100).toFixed(0)}%`
                color: root.iconColor
                font.pointSize: Global.fontSize
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
