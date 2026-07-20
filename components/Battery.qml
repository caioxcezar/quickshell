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
            property int iconLevel: Math.ceil(row.percentage * 10) * 10
            property string iconState: root.device.state == UPowerDeviceState.Charging && iconLevel != 100 ? "-charging-" : "-"

            spacing: 2

            IconColored {
                id: image

                anchors.verticalCenter: parent.verticalCenter
                source: Global.getIcon(`battery-level-${row.iconLevel}${row.iconState}symbolic`)
                iconColor: root.iconColor
            }

            Text {
                text: `${(row.percentage * 100).toFixed(0)}%`
                color: root.iconColor
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: Global.fontSize
            }
        }
    }
}
