import QtQuick
import qs.components
import qs.singletons

Rectangle {
    id: root

    required property var percentage
    required property var animationSpeed
    required property var icon
    color: Colors.surface
    radius: 10

    width: 220
    height: parent.height
    anchors.centerIn: parent

    Row {
        width: parent.width - 5
        height: parent.height
        spacing: 5

        Item {
            id: icon
            height: parent.height
            width: parent.height
            anchors.verticalCenter: parent.verticalCenter

            IconColored {

                anchors.centerIn: parent
                height: parent.height - 10
                width: parent.height - 10
                source: root.icon
                iconColor: Colors.font
            }
        }

        Item {
            width: parent.width - icon.width - 5
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: `${(root.percentage * 100).toFixed(0)}%`
                color: Colors.font
                font.pointSize: Global.fontSize
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
            }

            Rectangle {
                width: parent.width
                color: Colors.primary
                height: 10
                radius: 10
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: parent.width * root.percentage
                    color: Colors.font
                    height: 10
                    radius: 10
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on width {
                        NumberAnimation {
                            duration: root.animationSpeed
                        }
                    }
                }
            }
        }
    }
}
