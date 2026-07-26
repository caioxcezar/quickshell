pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property var powerCommands: [
        {
            "title": "Shutdown",
            "icon": "system-shutdown",
            "command": ["systemctl", "poweroff"]
        },
        {
            "title": "Reboot",
            "icon": "system-reboot",
            "command": ["systemctl", "reboot"]
        },
        {
            "title": "Suspend",
            "icon": "system-suspend",
            "command": ["systemctl", "suspend"]
        },
        {
            "title": "Log-out",
            "icon": "system-log-out",
            "for": "hyprland",
            "command": ["hyprctl", "dispatch", "hl.dsp.exit()"]
        },
        {
            "title": "Log-out",
            "icon": "system-log-out",
            "for": "niri",
            "command": ["niri", "msg", "action", "quit"]
        }
    ]

    function getIcon(name = "", fallback = "image-missing") {
        let icon = Quickshell.iconPath(name, true);

        if (icon)
            return icon;

        const lowercase = name.toLowerCase();
        if (lowercase.includes("steam_app"))
            icon = lowercase.replace("steam_app", "steam_icon");
        else if (lowercase.includes("steam"))
            icon = "steam";
        else if (lowercase.includes("discordcanery"))
            icon = "discord-canery";
        else if (lowercase.includes("zen"))
            icon = "app.zen_browser.zen";
        else if (lowercase.includes("wine"))
            icon = "wine";

        if (fallback)
            return Quickshell.iconPath(icon, fallback);
        const result = Quickshell.iconPath(icon, true);
        return result || null;
    }
}
