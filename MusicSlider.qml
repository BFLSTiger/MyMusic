import QtQuick
import QtQuick.Controls
import QtMultimedia

MySlider {
    value: player.position / player.duration
    enabled: player.source == "" ? false : true
    onMoved: {
        player.position = value * player.duration;
    }
    property int previousState
    onPressedChanged: {
        if(pressed === true)
        {
            previousState = player.playbackState;
            player.pause();
        }
        else
        {
            if(previousState === MediaPlayer.PlayingState)
                player.play();
        }
    }
}
