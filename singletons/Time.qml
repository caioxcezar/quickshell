import QtQuick
import Quickshell
pragma Singleton

Singleton {
    id: root

    readonly property string time: Qt.locale().toString(clock.date, "ddd d MMM yyyy HH:mm")
    readonly property int year: clock.date.getFullYear()
    readonly property int month: clock.date.getMonth()
    readonly property int day: clock.date.getDay()
    readonly property var clockDate: clock.date

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

}
