pragma ComponentBehavior: Bound
import QtQuick
import qs.components
import qs.singletons
import Quickshell

Item {
    id: root

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
                source: Quickshell.iconPath(root.current.icon ?? "")
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
                    color: Colors.font
                    font.pointSize: Global.fontSize
                    font.bold: true
                }

                Text {
                    text: `Temperature: ${root.current.temperature}${root.currentUnits.temperature}`
                    color: Colors.font
                    font.pointSize: Global.fontSize
                }

                Text {
                    text: `Wind: ${root.current.windSpeed} ${root.currentUnits.windSpeed} Direction: ${root.current.windDirection}${root.currentUnits.windDirection}`
                    color: Colors.font
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

                    Icon {
                        source: Quickshell.iconPath(weatherList.modelData.icon ?? "")
                        width: 24
                        height: 24
                    }

                    Column {
                        Text {
                            text: `${weatherList.modelData.temperature2mMin}${root.dailyUnits.temperature2mMin}`
                            color: Colors.font
                            font.pointSize: Global.fontSmall
                        }

                        Text {
                            text: `${weatherList.modelData.temperature2mMax}${root.dailyUnits.temperature2mMax}`
                            color: Colors.font
                            font.pointSize: Global.fontSmall
                        }
                    }
                }
            }
        }
    }
}
