pragma ComponentBehavior: Bound
import QtQuick
import qs.singletons
import qs.components

Item {
    id: root

    height: parent.height
    width: content.width + 6

    required property var window

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 6
        height: parent.height

        Menu {}

        Loader {
            readonly property Component hyprland: HyprWorkspaces {
                colors: root.window.colors
            }
            readonly property Component niri: NiriWorkspaces {
                screen: root.window.modelData
                colors: root.window.colors
            }

            height: parent.height

            sourceComponent: {
                switch (Global.compositor) {
                case "hyprland":
                    return hyprland;
                case "niri":
                    return niri;
                }
            }
        }
    }
}
