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
    property var actions: []
    property var action: null

    function isDefault(action) {
        const text = (action.text || "").trim().toLowerCase();
        return !text || text === "default";
    }

    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
        margins: 8
    }

    Component.onCompleted: {
        const actions = notification.actions ?? [];

        for (const action of actions) {
            if (isDefault(action))
                root.action = action;
            else
                root.actions.push(action);
        }
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: root.action?.invoke()
    }

    Item {
        width: parent.width
        height: 18

        IconImage {
            id: notifIcon

            anchors.verticalCenter: parent.verticalCenter
            width: 12
            height: 12
            source: Global.getIcon(root.notification.desktopEntry, true)
            visible: status === Image.Ready
        }

        IconRounded {
            id: closeIcon

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: parent.height
            height: parent.height
            iconSize: 12
            iconSource: Global.getIcon("view-close", true)
            iconColor: Colors.font

            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: root.notification.dismiss()
            }
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
                    return Global.getIcon(root.notification.image, true);

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
                elide: Text.ElideRight
                maximumLineCount: 3
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

    Text {
        text: {
            const time = root.notification.date;
            const timeFrmt = Qt.formatDateTime(root.notification.date, "dd/MM/yyyy HH:mm");

            return `${timeFrmt} (${calcDifference(new Date(), time)})`;
        }

        anchors.right: parent.right
        color: root.fontColor
        font.pointSize: Global.fontSmall

        function calcDifference(start, end) {
            const difference = start - end;

            if (difference < 1000)
                return "now";

            if (difference < 60000)
                return `${Math.floor(difference / 1000)}s`;

            if (difference < 3600000) {
                const [floor, rest] = division(difference, 60000);
                return `${floor}m ${Math.floor(rest * 60)}s`;
            }

            if (difference < 86400000) {
                const [floor, rest] = division(difference, 3600000);
                return `${floor}h ${Math.floor(rest * 60)}m`;
            }

            const [floor, rest] = division(difference, 86400000);
            return `${floor}d ${Math.floor(rest * 24)}h`;
        }

        function division(a, b) {
            const result = a / b;
            const floor = Math.floor(result);
            return [floor, result - floor];
        }
    }
}
