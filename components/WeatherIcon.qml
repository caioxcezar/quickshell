import qs.singletons
import QtQuick
import QtQuick.Layouts
import qs.components

Row {
    id: root

    required property var colors
    property var current: Weather.current ?? new Object()
    property var units: Weather.currentUnits ?? new Object()

    Layout.alignment: Qt.AlignVCenter

    Icon {
        id: weatherIcon
        source: Global.getIcon(root.current.icon, "")
        width: Global.iconSize
        height: Global.iconSize
    }

    Text {
        text: `${root.current.temperature || ""}${root.units.temperature || ""}`
        color: root.colors.font

        font.pointSize: Global.fontSize
    }
    visible: weatherIcon.status === Image.Ready
}
