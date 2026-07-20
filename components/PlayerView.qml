pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects
import qs.singletons

Column {
    id: root
    width: parent.width
    spacing: 6

    required property var music
    required property var colors
    property real percentage: music.position >= music.length ? 1 : Number((music.position / music.length).toFixed(2))
    property string imageSrc: Mpris.getTrackArtUrl(music)

    FrameAnimation {
        running: root.music.playbackState == Mpris.playbackState.Playing
        onTriggered: root.music.positionChanged()
    }

    Icon {
        source: Global.getIcon(root.music.desktopEntry, true)
        width: 12
        height: 12
        visible: status === Image.Ready
    }

    Row {
        spacing: 8
        width: parent.width

        Image {
            id: notifImage

            anchors.verticalCenter: parent.verticalCenter
            width: 100
            height: 100
            source: root.imageSrc
            fillMode: Image.PreserveAspectCrop
            visible: status === Image.Ready
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: notifImage.width
                    height: notifImage.height
                    radius: 5
                    visible: false
                }
            }
        }

        Column {
            width: parent.width - (notifImage.visible ? notifImage.width + 8 : 0)
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: root.music.trackTitle
                color: root.colors.font
                font.bold: true
                font.pointSize: Global.fontSize
                width: parent.width
                elide: Text.ElideRight
            }

            Text {
                text: root.music.trackArtist
                color: root.colors.font
                font.pointSize: Global.fontSize
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }
    }

    Column {
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6
            height: icon.height + 5

            Loader {
                active: root.music.canGoPrevious

                sourceComponent: IconRounded {
                    iconSource: Global.getIcon("media-skip-backward")
                    iconColor: root.colors.font
                    background: root.colors.primary

                    TapHandler {
                        acceptedButtons: Qt.LeftButton
                        onTapped: root.music.previous()
                    }
                }
            }

            IconRounded {
                id: icon

                iconSource: Global.getIcon(root.music.isPlaying ? "media-playback-pause" : "media-playback-start")
                iconColor: root.colors.font

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: root.music.isPlaying ? root.music.pause() : root.music.play()
                }
            }

            Loader {
                active: root.music.canGoNext

                sourceComponent: IconRounded {
                    iconSource: Global.getIcon("media-skip-forward")
                    iconColor: root.colors.font

                    TapHandler {
                        acceptedButtons: Qt.LeftButton
                        onTapped: root.music.next()
                    }
                }
            }
        }
        Loader {
            active: root.percentage < 1
            width: parent.width
            sourceComponent: Row {
                width: parent.width

                Rectangle {
                    width: parent.width
                    color: root.colors.primary
                    height: 10
                    radius: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        id: progressBar

                        width: parent.width * root.percentage
                        color: root.colors.font
                        height: 10
                        radius: 10
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
