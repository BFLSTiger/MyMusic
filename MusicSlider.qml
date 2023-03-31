import QtQuick 2.15
import QtQuick.Controls

MySlider {
    value: player.position / player.duration
    enabled: player.source == "" ? false : true
    onMoved: {
        player.position = value * player.duration;
    }
}
