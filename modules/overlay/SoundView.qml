pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.components
import qs.singletons

// qmllint disable uncreatable-type
Item {
    id: root

    property bool contentActive: false
    required property int animationSpeed
    required property var colors

    visible: false
    implicitWidth: 0
    implicitHeight: 300

    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: Global.marginBar

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
        color: root.colors.background
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
                    color: root.colors.surface
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
                            color: root.colors.font
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
                                color: root.colors.font
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
                                    context.fillStyle = root.colors.font;
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
                                    color: root.colors.surface
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
                                    color: itemDelegate.modelData === control.currentValue ? root.colors.error : root.colors.font
                                    font.bold: itemDelegate.highlighted
                                    verticalAlignment: Text.AlignVCenter
                                }
                                background: Rectangle {
                                    color: itemDelegate.highlighted ? root.colors.surface : "transparent"
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
                                IconColored {
                                    source: Pipewire.icon
                                    width: 24
                                    height: 24
                                    iconColor: root.colors.font

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
                                        color: root.colors.primary
                                        height: 10
                                        radius: Global.defaultRadius
                                        anchors.verticalCenter: parent.verticalCenter

                                        Rectangle {
                                            width: parent.width * Pipewire.output.audio.volume
                                            color: root.colors.font
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
                    color: root.colors.surface

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    radius: Global.defaultRadius

                    ColumnLayout {
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent

                        Text {
                            text: "Applications"
                            Layout.alignment: Qt.AlignHCenter

                            color: root.colors.font
                            font.pointSize: Global.fontSize
                            font.bold: true
                        }

                        ListView {
                            model: Pipewire.programs.filter(p => p.properties["pulse.corked"] !== "true")
                            clip: true
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 4

                            delegate: Column {
                                id: item
                                width: parent.width

                                required property var modelData
                                property string iconName: (item.modelData?.properties?.["application.icon-name"] || "")
                                property string binary: (item.modelData?.properties?.["application.process.binary"] || "")
                                property string name: (item.modelData.name || "")

                                Text {
                                    text: item.name
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: root.colors.font
                                    font.pointSize: Global.fontSmall
                                }

                                Row {

                                    width: parent.width

                                    Icon {
                                        id: appIcon
                                        source: Global.getIcon(item.iconName || item.name || item.binary, true)
                                        width: 24
                                        height: 24
                                        visible: status === Image.Ready
                                    }

                                    IconColored {
                                        id: soundIcon
                                        source: Pipewire.getVolumeIcon(item.modelData.audio.volume, item.modelData.audio.muted)
                                        iconColor: root.colors.font
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
                                        width: parent.width - soundIcon.width - (appIcon.visible ? appIcon.width : 0)
                                        height: parent.height
                                        Rectangle {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: parent.width - 10
                                            color: root.colors.primary
                                            height: 10
                                            radius: Global.defaultRadius
                                            anchors.verticalCenter: parent.verticalCenter

                                            Rectangle {
                                                width: parent.width * item.modelData.audio.volume
                                                color: root.colors.font
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
}
