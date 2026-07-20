pragma ComponentBehavior: Bound
import QtQuick
import qs.components
import qs.singletons
import Quickshell

Item {
    id: root

    required property var colors
    property var current: Weather.current ?? new Object()
    property var currentUnits: Weather.currentUnits ?? new Object()
    property var dailyUnits: Weather.dailyUnits ?? new Object()

    implicitHeight: content.implicitHeight

    Column {
        id: content
        Row {
            width: parent.width
            Icon {
                anchors.verticalCenter: parent.verticalCenter
                source: Global.getIcon(root.current.icon ?? "")
                width: 48
                height: 48
            }

            Column {
                Text {
                    text: root.current.wmo
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    wrapMode: Text.WordWrap
                    width: parent.width
                    color: root.colors.font
                    font.pointSize: Global.fontSize
                    font.bold: true
                }

                Text {
                    text: `Temperature: ${root.current.temperature}${root.currentUnits.temperature}`
                    color: root.colors.font
                    font.pointSize: Global.fontSize
                }

                Text {
                    text: `Wind: ${root.current.windSpeed} ${root.currentUnits.windSpeed} Direction: ${root.current.windDirection}${root.currentUnits.windDirection}`
                    color: root.colors.font
                    font.pointSize: Global.fontSize
                }
            }
        }

        Row {
            spacing: 6

            Repeater {
                model: Weather.daily

                Column {
                    id: weatherList
                    required property var modelData

                    IconColored {
                        source: Global.getIcon(weatherList.modelData.icon ?? "")
                        width: 24
                        height: 24
                        iconColor: root.colors.font
                    }

                    Column {
                        Text {
                            text: `${weatherList.modelData.temperature2mMin}${root.dailyUnits.temperature2mMin}`
                            color: root.colors.font
                            font.pointSize: Global.fontSmall
                        }

                        Text {
                            text: `${weatherList.modelData.temperature2mMax}${root.dailyUnits.temperature2mMax}`
                            color: root.colors.font
                            font.pointSize: Global.fontSmall
                        }
                    }
                }
            }
        }
    }
}
