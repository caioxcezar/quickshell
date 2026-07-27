pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.UPower
import qs.components
import qs.singletons

Item {
    id: root

    required property var iconColor
    property var device: UPower.devices.values[0]

    width: loader.width
    height: parent.height

    Loader {
        id: loader

        anchors.centerIn: parent
        active: Boolean(root.device)

        sourceComponent: Row {
            id: row

            property real percentage: root.device.percentage
            property string icon: {
                const level = Math.ceil(row.percentage * 10) * 10;
                const isCharging = root.device.state == UPowerDeviceState.Charging;

                if (level === 100)
                    return isCharging ? "battery-charged" : "battery-full";

                return `battery-0${level}${isCharging ? "-charging" : ""}`;
            }

            spacing: 2

            IconColored {
                id: image

                anchors.verticalCenter: parent.verticalCenter
                source: Global.getIcon(row.icon)
                iconColor: root.iconColor
            }

            Text {
                text: `${(row.percentage * 100).toFixed(0)}%`
                color: root.iconColor
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: Styles.fontSize
            }
        }
    }
}
