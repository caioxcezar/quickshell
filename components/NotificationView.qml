pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import qs.singletons

Column {
    id: root

    required property var notification
    property string fontColor: Colors.font
    property var actions: notification.actions ?? []

    spacing: 6

    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
        margins: 8
    }

    Row {
        width: parent.width

        IconImage {
            id: notifIcon

            anchors.verticalCenter: parent.verticalCenter
            width: 12
            height: 12
            source: root.notification.appIcon || Quickshell.iconPath(root.notification.appName.toLowerCase(), true)
            visible: status === Image.Ready
        }
    }

    Row {
        spacing: 8
        width: parent.width

        Image {
            id: notifImage

            anchors.verticalCenter: parent.verticalCenter
            width: 32
            height: 32
            source: {
                const iconPath = root.notification.image;
                if (!root.notification.image)
                    return "";

                if (iconPath.toString().startsWith("image://icon/"))
                    return Quickshell.iconPath(root.notification.image, true);

                return iconPath;
            }
            fillMode: Image.PreserveAspectCrop
            visible: status === Image.Ready
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: notifImage.width
                    height: notifImage.height
                    radius: 5
                    visible: false
                }
            }
        }

        Column {
            width: parent.width - (notifImage.visible ? notifImage.width + 8 : 0)
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: root.notification.summary
                color: root.fontColor
                font.bold: true
                width: parent.width
                elide: Text.ElideRight
                font.pointSize: Global.fontSubtitle
            }

            Text {
                text: root.notification.body
                color: root.fontColor
                wrapMode: Text.WordWrap
                width: parent.width
                font.pointSize: Global.fontSize
            }
        }
    }

    Row {
        spacing: 5
        width: parent.width
        visible: root.actions.length

        Repeater {
            model: root.actions

            Rectangle {
                required property var modelData
                height: actionLabel.implicitHeight + 10
                width: actionLabel.implicitWidth + 16
                color: Colors.primary
                radius: 4

                Text {
                    id: actionLabel

                    anchors.centerIn: parent
                    text: parent.modelData.text
                    color: Colors.font
                    font.pointSize: Global.fontSize
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: parent.modelData.invoke()
                }
            }
        }
    }
}
