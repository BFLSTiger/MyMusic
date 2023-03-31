import QtQuick 2.15
import QtMultimedia

Rectangle {
    width: 25
    height: 25
    Image {
        mipmap: true
        id: playButtonImg
        anchors.fill: parent
        source: player.playbackState === MediaPlayer.PlayingState ? (playButtonArea.containsMouse || playButtonArea.pressed ? "qrc:/src/png/pause-active.png" : "qrc:/src/png/pause.png")
                                                                  : (playButtonArea.containsMouse || playButtonArea.pressed ? "qrc:/src/png/play-active.png" : "qrc:/src/png/play.png")
        anchors.centerIn: parent
    }
    MouseArea {
        id: playButtonArea
        anchors.fill: parent
        enabled: player.source == "" ? false : true
        hoverEnabled: player.source == "" ? false : true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.CustomCursor
        onPressed: {
            playButtonImg.scale = 0.9;
        }
        onReleased: {
            playButtonImg.scale = 1;
            if(player.playbackState === MediaPlayer.PlayingState) {
                player.pause();
            }
            else {
                player.play();
            }
        }
    }
}
