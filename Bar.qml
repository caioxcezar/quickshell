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
            implicitHeight: Styles.height
            color: Colors.surface

            anchors {
                top: true
                left: true
                right: true
            }

            Component.onCompleted: {
                Idle.window = panelWindow;
            }

            Loader {
                anchors.fill: parent
                active: PreLoading.finished

                sourceComponent: Item {
                    anchors.fill: parent

                    LeftBar {
                        window: panelWindow
                        anchors.left: parent.left
                    }

                    Context {
                        window: panelWindow
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
}
