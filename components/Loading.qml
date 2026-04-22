pragma ComponentBehavior: Bound
import QtQuick

Row {
    id: root

    property int animationSpeed: 500

    anchors.centerIn: parent
    spacing: 26

    Repeater {
        model: [
            {
                "id": 1,
                "color": "#4285f5"
            },
            {
                "id": 2,
                "color": "#ea4436"
            },
            {
                "id": 3,
                "color": "#fbbd06"
            },
            {
                "id": 4,
                "color": "#34a952"
            },
            {
                "id": 5,
                "color": "#cf9fff"
            }
        ]

        Rectangle {
            id: rect
            required property var modelData

            width: 16
            height: 16
            radius: 8
            color: modelData.color

            Rectangle {
                id: inner

                anchors.centerIn: parent
                opacity: 0.5
                width: 0
                height: 0
                radius: 16
                color: rect.modelData.color

                Timer {
                    interval: root.animationSpeed * rect.modelData.id
                    running: true
                    onTriggered: {
                        animation.from = 0;
                        animation.to = 32;
                        animation.start();
                        timerRestart.start();
                    }
                }

                Timer {
                    id: timerRestart

                    interval: root.animationSpeed * 5
                    repeat: true
                    running: false
                    onTriggered: {
                        animation.from = animation.from == 0 ? 32 : 0;
                        animation.to = animation.to == 0 ? 32 : 0;
                        animation.start();
                    }
                }

                ParallelAnimation {
                    id: animation

                    property int from: 0
                    property int to: 32

                    NumberAnimation {
                        from: animation.from
                        to: animation.to
                        target: inner
                        property: "width"
                        duration: root.animationSpeed
                        easing.type: Easing.OutCubic
                    }

                    NumberAnimation {
                        from: animation.from
                        to: animation.to
                        target: inner
                        property: "height"
                        duration: root.animationSpeed
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
