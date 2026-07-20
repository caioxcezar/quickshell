pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property var screens: new Object()

    readonly property string fontLight: '#1d1d1d'
    readonly property string backgroundLight: "#37ffffff"
    readonly property string surfaceLight: '#f1f1f1'
    readonly property string errorLight: "#ff6b6b"
    readonly property string primaryLight: "#4c4c4c"

    readonly property string fontDark: "#eff0f1"
    readonly property string backgroundDark: '#a01d1d1d'
    readonly property string surfaceDark: "#000000"
    readonly property string errorDark: "#ff6b6b"
    readonly property string primaryDark: "#4c4c4c"

    function getColorsByScreen(screen) {
        return getColorsByTheme(screens[screen]);
    }

    function getColorsByTheme(theme) {
        return theme === "dark" ? {
            "font": fontDark,
            "background": backgroundDark,
            "surface": surfaceDark,
            "error": errorDark,
            "primary": primaryDark
        } : {
            "font": fontLight,
            "background": backgroundLight,
            "surface": surfaceLight,
            "error": errorLight,
            "primary": primaryLight
        };
    }
}
