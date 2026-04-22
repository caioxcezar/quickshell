import QtQuick
import Quickshell
import Quickshell.Services.Notifications
pragma Singleton

NotificationServer {
    id: notifications

    readonly property ObjectModel list: notifications.trackedNotifications
    property bool isMuted: false

    signal notificationReceived(var notification)

    imageSupported: true
    actionIconsSupported: true
    keepOnReload: true
    persistenceSupported: true
    bodyImagesSupported: true
    actionsSupported: true
    bodyMarkupSupported: true
    bodySupported: true
    onNotification: (notif) => {
        if (isMuted || notif.transient) {
            notif.dismiss();
        } else {
            notif.tracked = true;
            notificationReceived(notif);
        }
    }
}
