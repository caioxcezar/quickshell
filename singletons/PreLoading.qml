pragma Singleton
import Quickshell

Singleton {
    property bool lockscreenLoaded: false
    property bool luminanceLoaded: false
    property bool finished: lockscreenLoaded && luminanceLoaded
}
