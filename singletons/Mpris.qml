import Quickshell
import Quickshell.Services.Mpris
pragma Singleton

Singleton {
    readonly property var players: Mpris.players.values.map((player) => {
        if (player.trackArtUrl) trackArtUrl[getId(player)] = player.trackArtUrl;
        return player;
    })
    readonly property bool isPlaying: players.length > 0 && players.some(({ isPlaying }) => isPlaying)
    readonly property var playbackState: MprisPlaybackState
    property var trackArtUrl: new Object();

    function getId(player) {
        return `${player.dbusName}:${player.uniqueId}`
    }
    function getTrackArtUrl(player) {
        return trackArtUrl[getId(player)] ?? "";
    }
}
