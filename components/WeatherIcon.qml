import qs.singletons
import QtQuick
import QtQuick.Layouts
import qs.components

Row {
    id: root

    property var current: Weather.current ?? new Object()
    property var units: Weather.currentUnits ?? new Object()

    Layout.alignment: Qt.AlignVCenter

    Icon {
        id: weatherIcon
        source: Global.getIcon(root.current.icon, "")
        width: Styles.iconSize
        height: Styles.iconSize
    }

    Text {
        text: `${root.current.temperature || ""}${root.units.temperature || ""}`
        color: Colors.primaryText

        font.pointSize: Styles.fontSize
    }
    visible: weatherIcon.status === Image.Ready
}
