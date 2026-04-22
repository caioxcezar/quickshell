pragma ComponentBehavior: Bound
import Qt5Compat.GraphicalEffects
import QtQuick
import qs.components
import qs.singletons

Item {
    id: root

    width: content.width + 5
    height: parent.height

    required property var window

    Rectangle {
        id: rect

        width: content.width
        height: parent.height - 5
        radius: 5
        color: Colors.surface
        layer.enabled: true
        anchors.centerIn: parent

        layer.effect: OpacityMask {
            invert: true

            maskSource: Item {
                width: rect.width
                height: rect.height

                Rectangle {
                    radius: 10
                    x: power.x + 5
                    y: power.y
                    anchors.verticalCenter: parent.verticalCenter
                    width: Global.iconContainer
                    height: Global.iconContainer
                    color: "black"
                }
            }
        }
    }

    Item {
        id: content

        anchors.centerIn: parent
        width: row.width + 10
        height: parent.height - 5

        Row {
            id: row

            anchors.centerIn: parent
            spacing: 2

            Tray {
                window: root.window
            }

            Caffeine {}

            Sound {
                anchors.verticalCenter: parent.verticalCenter
            }

            Battery {
                anchors.verticalCenter: parent.verticalCenter
            }

            Power {
                id: power

                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
