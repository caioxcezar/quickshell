pragma ComponentBehavior: Bound
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import qs.components
import qs.singletons
import qs.modules.bar

ShellRoot {
    id: root

    property bool firstBoot: !Global.dev

    Timer {
        interval: 500
        repeat: false
        running: true
        onTriggered: {
            lock.locked = false;
            root.firstBoot = false;
        }
    }

    Connections {
        function onIsLockedChanged() {
            if (Idle.isLocked)
                lock.locked = true;
        }

        target: Idle
    }

    WlSessionLock {
        id: lock

        locked: !Global.dev

        WlSessionLockSurface {
            id: surface

            color: "transparent"

            ScreencopyView {
                id: screencopy

                paintCursor: false
                anchors.fill: parent
                captureSource: surface.screen
                live: false
                layer.enabled: true

                layer.effect: FastBlur {
                    radius: 64
                }
            }

            PamContext {
                id: pam

                property string secret: ""
                property bool error: false

                configDirectory: "/etc/pam.d"
                config: "login"
                onCompleted: result => {
                    pam.secret = "";
                    error = [PamResult.Error, PamResult.Failed].includes(result);
                    if (result === PamResult.Success) {
                        // Both needs to change because of the lockscreen shortcut
                        Idle.isLocked = false;
                        lock.locked = false;
                    }
                }
                onPamMessage: {
                    if (pam.responseRequired)
                        respond(pam.secret);
                }
            }

            Connections {
                function onActiveChanged() {
                    Idle.isAuthenticating = pam.active;
                }

                target: pam
            }

            Rectangle {
                width: tray.width
                height: Global.height
                color: "transparent"
                anchors {
                    top: parent.top
                    right: parent.right
                    margins: 5
                }

                RightBar {
                    id: tray
                    window: root
                    anchors.right: parent.right
                }
            }

            Rectangle {
                width: 500
                height: parent.height
                color: "transparent"
                anchors.bottom: parent.bottom

                PlayerList {
                    verticalLayoutDirection: ListView.BottomToTop

                    header: Item {
                        height: 5
                    }
                }
            }

            Row {
                spacing: 64
                anchors.centerIn: parent

                Loader {
                    readonly property Component loading: Loading {
                        animationSpeed: 200
                    }

                    readonly property Component input: Column {
                        anchors.centerIn: parent
                        spacing: 16

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: Time.time
                            color: Colors.font
                            font.pointSize: Global.fontTitle
                            font.bold: true
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Screen Locked"
                            color: Colors.font
                            font.pointSize: Global.fontTitle
                            font.bold: true
                        }

                        TextField {
                            id: passwordField

                            text: pam.secret
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 300
                            height: 40
                            placeholderText: "Enter password..."
                            placeholderTextColor: Colors.font
                            echoMode: TextInput.Password
                            color: Colors.font
                            Keys.onReturnPressed: {
                                pam.user = Qt.binding(() => {
                                    return Quickshell.env("USER");
                                });
                                pam.start();
                            }
                            onTextChanged: {
                                pam.secret = passwordField.text;
                            }
                            Component.onCompleted: {
                                passwordField.text = "";
                                pam.secret = "";
                                passwordField.forceActiveFocus();
                            }

                            background: Rectangle {
                                color: Colors.surface
                                radius: 8
                            }
                        }

                        Text {
                            id: errorText

                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Incorrect password"
                            color: Colors.error
                            font.pointSize: Global.fontSubtitle
                            visible: pam.error
                        }
                    }

                    sourceComponent: pam.active || root.firstBoot ? loading : input
                }
            }
        }
    }
}
