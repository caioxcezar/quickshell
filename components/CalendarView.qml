pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import qs.singletons

ListView {
    id: root

    required property var colors

    width: 200
    height: 200
    snapMode: ListView.SnapOneItem
    orientation: ListView.Vertical
    highlightRangeMode: ListView.StrictlyEnforceRange
    Component.onCompleted: {
        Qt.callLater(() => root.positionViewAtIndex(Time.month, ListView.Beginning));
    }

    model: CalendarModel {
        from: new Date(Time.year, 0, 1)
        to: new Date(Time.year, 12, 1)
    }

    delegate: Column {
        id: item
        width: root.width
        height: root.height

        required property var modelData

        Text {
            width: root.width
            text: Qt.formatDateTime(new Date(item.modelData.year, item.modelData.month, 1), "MMMM yyyy")
            font.pointSize: Global.fontTitle
            color: root.colors.font
        }

        DayOfWeekRow {
            id: weekRow

            locale: grid.locale
            width: root.width

            delegate: Text {
                required property string shortName

                text: shortName
                font.pointSize: Global.fontSubtitle
                font.bold: true
                color: root.colors.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        MonthGrid {
            id: grid

            width: root.width
            month: item.modelData.month
            year: item.modelData.year
            locale: Qt.locale()

            delegate: Item {
                required property var model

                implicitWidth: dayText.implicitWidth
                implicitHeight: dayText.implicitHeight

                Rectangle {
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height)
                    height: width
                    radius: width / 2
                    color: parent.model.today ? root.colors.error : "transparent"
                }

                Text {
                    id: dayText
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    opacity: parent.model.month === grid.month ? 1 : 0
                    text: grid.locale.toString(parent.model.date, "d")
                    font.pointSize: Global.fontSize
                    color: root.colors.font
                }
            }
        }
    }

    ScrollIndicator.horizontal: ScrollIndicator {}
}
