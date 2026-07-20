pragma ComponentBehavior: Bound
import QtQuick
import qs.singletons

Rectangle {
    id: root

    property string iconSource
    property string iconColor
    property string background

    property int iconSize: Global.iconSize

    width: Global.iconContainer
    height: Global.iconContainer
    color: root.background
    radius: 10

    Loader {
        readonly property Component icon: Icon {
            width: root.iconSize
            height: root.iconSize
            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
            source: root.iconSource
        }

        readonly property Component iconWithColor: IconColored {
            width: root.iconSize
            height: root.iconSize
            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
            source: root.iconSource
            iconColor: root.iconColor
        }

        anchors.centerIn: parent
        sourceComponent: Boolean(root.iconColor) ? iconWithColor : icon
    }
}
