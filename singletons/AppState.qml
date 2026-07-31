pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property string compositor: "hyprland"
    readonly property bool dev: false
    property bool powerVisibility: false
    property bool volumeContextVisibility: false
    property bool brightnessContextVisibility: false
}
