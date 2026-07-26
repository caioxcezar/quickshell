pragma ComponentBehavior: Bound
import QtQuick
import qs.singletons

Item {
    id: root

    height: parent.height
    width: content.width + Styles.horizontalMargin

    required property var window

    Row {
        id: content

        anchors.centerIn: parent
        spacing: Styles.margin
        height: parent.height

        // Menu {}

        Loader {
            readonly property Component hyprland: HyprWorkspaces {}
            readonly property Component niri: NiriWorkspaces { screen: root.window.modelData }

            height: parent.height

            sourceComponent: {
                switch (AppState.compositor) {
                case "hyprland":
                    return hyprland;
                case "niri":
                    return niri;
                }
            }
        }
    }
}
