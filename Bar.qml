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

                Workspaces {
                    id: workspaces
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
