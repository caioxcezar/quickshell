pragma ComponentBehavior: Bound
import QtQuick
import qs.singletons
import qs.components

Item {
    id: root

    width: content.width
    height: parent.height

    required property var window

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 2
        height: parent.height

        Menu {}

        Loader {
            readonly property Component hyprland: HyprWorkspaces {}
            readonly property Component niri: NiriWorkspaces {
                screen: root.window.modelData
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
