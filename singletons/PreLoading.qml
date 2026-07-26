pragma Singleton
import Quickshell

Singleton {
    property bool lockscreenLoaded: false
    property bool luminanceLoaded: true
    property bool finished: lockscreenLoaded && luminanceLoaded
}
