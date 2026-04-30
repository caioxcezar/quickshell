pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.bar
import qs.singletons

Scope {
    Variants {
        model: Quickshell.screens

        // qmllint disable uncreatable-type
        PanelWindow {
            id: panelWindow

            required property var modelData

            WlrLayershell.namespace: "quickshell:bar"
            screen: modelData
            implicitHeight: Global.height
            color: "transparent"

            // qmllint disable unqualified unresolved-type missing-property
            margins {
                top: 5
                left: 5
                right: 5
            }
            // qmllint enable unqualified unresolved-type missing-property

            anchors {
                top: true
                left: true
                right: true
            }

            Component.onCompleted: {
                Idle.window = panelWindow;
            }

            Rectangle {
                anchors.fill: parent
                color: Colors.background
                radius: 5

                Loader {
                    id: workspaces
                    readonly property Component hyprland: HyprWorkspaces {}
                    readonly property Component niri: NiriWorkspaces {
                        screen: panelWindow.modelData
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

                Context {
                    anchors.centerIn: parent
                }

                RightBar {
                    id: rightBar
                    window: panelWindow
                    anchors.right: parent.right
                }
            }
        }
    }
}
