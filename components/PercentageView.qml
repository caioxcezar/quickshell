import QtQuick
import qs.components
import qs.singletons

Rectangle {
    id: root

    required property var percentage
    required property var animationSpeed
    required property var icon
    color: Colors.surfaceVariant
    radius: Styles.defaultRadius

    width: 200
    height: 200
    anchors.centerIn: parent

    Column {
        anchors.fill: parent

        IconColored {
            height: 180
            width: 180
            source: root.icon
            iconColor: Colors.primaryText
        }

        Rectangle {
            width: parent.width - Styles.horizontalMargin
            color: Colors.primary
            height: Styles.fontSize
            radius: Styles.defaultRadius
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                width: parent.width * root.percentage
                color: Colors.primaryText
                height: Styles.fontSize
                radius: Styles.defaultRadius
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

    



    // Row {
    //     width: parent.width
    //     height: parent.height
    //     spacing: 5

    //     Item {
    //         id: icon
    //         height: parent.height
    //         width: parent.height
    //         anchors.verticalCenter: parent.verticalCenter
    //     }

    //     Item {
    //         width: parent.width - icon.width - 5
    //         height: parent.height
    //         anchors.verticalCenter: parent.verticalCenter

    //         Text {
    //             text: `${(root.percentage * 100).toFixed(0)}%`
    //             color: Colors.primaryText
    //             font.pointSize: Styles.fontSize
    //             anchors.horizontalCenter: parent.horizontalCenter
    //             anchors.top: parent.top
    //         }

    //         Rectangle {
    //             width: parent.width
    //             color: Colors.primary
    //             height: 10
    //             radius: 10
    //             anchors.verticalCenter: parent.verticalCenter

    //             Rectangle {
    //                 width: parent.width * root.percentage
    //                 color: Colors.primaryText
    //                 height: 10
    //                 radius: 10
    //                 anchors.left: parent.left
    //                 anchors.verticalCenter: parent.verticalCenter

    //                 Behavior on width {
    //                     NumberAnimation {
    //                         duration: root.animationSpeed
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }
}
