pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.components
import qs.singletons
import QtQuick.Controls
import QtQuick.Layouts

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    property bool contentActive: false
    property int animationSpeed: Global.animationSpeed / 2

    anchors.top: true
    anchors.right: true
    visible: false
    exclusiveZone: -1
    implicitWidth: 0
    implicitHeight: 300
    color: "transparent"
    // qmllint disable unqualified unresolved-type missing-property
    margins.top: Global.height + Global.marginBar + 5
    // qmllint enable unqualified unresolved-type missing-property

    Component.onCompleted: {
        Pipewire.modal = root;
        Pipewire.animation = animation;
    }

    NumberAnimation {
        id: animation

        onStopped: {
            if (Pipewire.isOpen)
                root.contentActive = true;

            if (!root.implicitWidth)
                root.visible = false;

            Pipewire.animationFinished(Pipewire.isOpen);
        }
        onStarted: {
            if (!Pipewire.isOpen)
                root.contentActive = false;
        }
        target: root
        property: "implicitWidth"
        duration: root.animationSpeed
        easing.type: Easing.OutCubic
    }

    Rectangle {
        anchors.fill: parent
        clip: true
        color: Colors.background
        topLeftRadius: Global.defaultRadius
        bottomLeftRadius: Global.defaultRadius

        Loader {
            active: root.contentActive
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent

            sourceComponent: ColumnLayout {
                anchors.fill: parent

                spacing: 4

                Rectangle {
                    color: Colors.surface
                    Layout.fillWidth: true
                    height: outputDefault.height + 10
                    radius: Global.defaultRadius

                    Column {
                        id: outputDefault
                        width: parent.width - 10
                        anchors.centerIn: parent

                        Text {
                            text: "Device"
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Colors.font
                            font.pointSize: Global.fontSize
                            font.bold: true
                        }

                        ComboBox {
                            id: control
                            width: parent.width
                            height: 40
                            currentValue: Pipewire.output
                            model: Pipewire.outputs
                            textRole: "description"
                            onActivated: Pipewire.setOutput(currentValue)
                            background: Rectangle {
                                color: "transparent"
                            }
                            contentItem: Text {
                                text: control.displayText
                                font: control.font
                                color: Colors.font
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            indicator: Canvas {
                                id: canvas
                                x: control.width - width - control.rightPadding
                                y: control.topPadding + (control.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"

                                onPaint: {
                                    context.reset();
                                    context.moveTo(0, 0);
                                    context.lineTo(width, 0);
                                    context.lineTo(width / 2, height);
                                    context.closePath();
                                    context.fillStyle = Colors.font;
                                    context.fill();
                                }
                            }

                            popup: Popup {
                                y: control.height
                                width: control.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: control.popup.visible ? control.delegateModel : null
                                    currentIndex: control.highlightedIndex
                                    ScrollIndicator.vertical: ScrollIndicator {}
                                }

                                background: Rectangle {
                                    radius: Global.defaultRadius
                                    color: Colors.background
                                }
                            }

                            delegate: ItemDelegate {
                                id: itemDelegate
                                required property var modelData
                                required property var index
                                width: control.width
                                highlighted: control.highlightedIndex === index
                                contentItem: Text {
                                    text: itemDelegate.modelData.description
                                    color: itemDelegate.highlighted ? Colors.font : Colors.surface
                                    font.bold: itemDelegate.modelData === control.currentValue
                                    verticalAlignment: Text.AlignVCenter
                                }
                                background: Rectangle {
                                    color: itemDelegate.highlighted ? Colors.surface : "transparent"
                                    radius: Global.defaultRadius
                                }
                            }
                        }

                        Loader {
                            width: parent.width
                            active: Boolean(Pipewire.output?.audio)
                            sourceComponent: Row {
                                width: parent.width
                                height: 24
                                Icon {
                                    source: Pipewire.icon
                                    width: 24
                                    height: 24

                                    TapHandler {
                                        acceptedButtons: Qt.LeftButton
                                        onTapped: {
                                            Pipewire.output.audio.muted = !Pipewire.output.audio.muted;
                                        }
                                    }
                                }

                                Item {
                                    width: parent.width - 24
                                    height: parent.height
                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: parent.width - 10
                                        color: Colors.primary
                                        height: 10
                                        radius: Global.defaultRadius
                                        anchors.verticalCenter: parent.verticalCenter

                                        Rectangle {
                                            width: parent.width * Pipewire.output.audio.volume
                                            color: Colors.font
                                            height: 10
                                            radius: Global.defaultRadius
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter

                                            Behavior on width {
                                                NumberAnimation {
                                                    duration: Global.animationSpeed / 2
                                                }
                                            }
                                        }

                                        TapHandler {
                                            acceptedButtons: Qt.LeftButton
                                            onTapped: e => {
                                                const volume = Number(e.position.x / parent.width).toFixed(2);
                                                Pipewire.output.audio.volume = Number(volume);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    color: Colors.surface

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    radius: Global.defaultRadius

                    ColumnLayout {
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent

                        Text {
                            text: "Applications"
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Colors.font
                            font.pointSize: Global.fontSize
                            font.bold: true
                        }

                        ListView {
                            model: Pipewire.programs
                            clip: true
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 4

                            delegate: Row {
                                id: item
                                width: parent.width
                                required property var modelData

                                Icon {
                                    source: {
                                        const iconName = (item.modelData?.properties?.["application.icon-name"] || "").toLowerCase();
                                        const binary = (item.modelData?.properties?.["application.process.binary"] || "").toLowerCase();
                                        const name = (item.modelData.name || "").toLowerCase();

                                        let icon = iconName || name;

                                        if (binary.includes("steam"))
                                            icon = "steam";
                                        else if (binary.includes("discordcanery"))
                                            icon = "discord-canery";
                                        else if (icon.includes("zen"))
                                            icon = "app.zen_browser.zen";

                                        return Quickshell.iconPath(icon, "image-missing");
                                    }
                                    width: 24
                                    height: 24
                                }

                                Icon {
                                    source: Pipewire.getVolumeIcon(item.modelData.audio.volume, item.modelData.audio.muted)
                                    width: 24
                                    height: 24

                                    TapHandler {
                                        acceptedButtons: Qt.LeftButton
                                        onTapped: {
                                            item.modelData.audio.muted = !item.modelData.audio.muted;
                                        }
                                    }
                                }

                                Item {
                                    width: parent.width - 48
                                    height: parent.height
                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: parent.width - 10
                                        color: Colors.primary
                                        height: 10
                                        radius: Global.defaultRadius
                                        anchors.verticalCenter: parent.verticalCenter

                                        Rectangle {
                                            width: parent.width * item.modelData.audio.volume
                                            color: Colors.font
                                            height: 10
                                            radius: Global.defaultRadius
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter

                                            Behavior on width {
                                                NumberAnimation {
                                                    duration: Global.animationSpeed / 2
                                                }
                                            }
                                        }

                                        TapHandler {
                                            acceptedButtons: Qt.LeftButton
                                            onTapped: e => {
                                                const volume = Number(e.position.x / parent.width).toFixed(2);
                                                item.modelData.audio.volume = Number(volume);
                                            }
                                        }
                                    }
                                }

                                WheelHandler {
                                    orientation: Qt.Vertical
                                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                    onWheel: e => {
                                        if (e.angleDelta.y > 0 && item.modelData.audio.volume >= 1)
                                            return;
                                        if (e.angleDelta.y < 0 && item.modelData.audio.volume <= 0)
                                            return;

                                        const change = e.angleDelta.y > 0 ? 0.01 : -0.01;

                                        const volume = Number(item.modelData.audio.volume + change).toFixed(2);
                                        item.modelData.audio.volume = volume;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
