pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.singletons

Singleton {
    id: root

    property bool isLocked: false
    property bool isAuthenticating: false
    property bool onCaffeine: false
    property var window: null
    // qmllint disable unresolved-type
    GlobalShortcut {
        name: "lock-screen"
        description: "Lock the screen"
        onPressed: {
            root.isLocked = true;
        }
    }
    // qmllint enable unresolved-type

    IdleInhibitor {
        enabled: root.onCaffeine
        window: root.window
    }

    IdleMonitor {
        id: brightness

        property int prevBrightness: 0

        timeout: 450
        respectInhibitors: true
        onIsIdleChanged: {
            if (brightness.isIdle) {
                Brightness.setIdleBrightness(1);
            } else {
                Brightness.resetIdleBrightness();
            }
        }
    }

    IdleMonitor {
        id: monitor

        respectInhibitors: true
        timeout: 900
        onIsIdleChanged: {
            root.isLocked = monitor.isIdle;
        }
    }
}
