pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import qs.singletons

ListView {
    id: root

    width: 200
    height: 200
    snapMode: ListView.SnapOneItem
    orientation: ListView.Vertical
    highlightRangeMode: ListView.StrictlyEnforceRange
    Component.onCompleted: {
        currentIndex = Time.month;
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
            color: Colors.font
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
                color: Colors.font
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

            delegate: Text {
                required property var model

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: model.month === grid.month ? 1 : 0
                text: grid.locale.toString(model.date, "d")
                font.pointSize: Global.fontSize
                color: model.today ? Colors.error : Colors.font
            }
        }
    }

    ScrollIndicator.horizontal: ScrollIndicator {}
}
