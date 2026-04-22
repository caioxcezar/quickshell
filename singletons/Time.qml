import QtQuick
import Quickshell
pragma Singleton

Singleton {
    id: root

    readonly property string time: Qt.formatDateTime(clock.date, "ddd MMM d HH:mm yyyy")
    readonly property int year: clock.date.getFullYear()
    readonly property int month: clock.date.getMonth()
    readonly property int day: clock.date.getDay()
    readonly property var clockDate: clock.date

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

}
