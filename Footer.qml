import QtQuick
import QtQuick.Controls
import "src/js/time.js" as Time

Rectangle {
    width: parent.width
    height: 70
    anchors.bottom: parent.bottom
    MusicSlider {
        id: musicSlider
        width: parent.width
        anchors.top: parent.top
    }
    Label {
        id: infoLabel
        text: body.songName
        anchors.left: parent.left
        anchors.right: playButton.left
        elide: Text.ElideRight
        anchors.leftMargin: 80
        anchors.rightMargin: 40
        font.pixelSize: 14
        anchors.verticalCenter: parent.verticalCenter
    }
    PlayButton {
        id: playButton
        anchors.centerIn: parent
    }
    NextButton {
        id: nextButton
        anchors.left: playButton.right
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
    }
    OrderButton {
        id: orderButton
        anchors.left: nextButton.right
        anchors.leftMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        onTypeChanged: {
            player.type = type;
        }
    }
    VolumeArea {
        id: volumeArea
        anchors.left: orderButton.right
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
    }
    Label {
        id: timeLabel
        text: "%1/%2".arg(Time.fromMs(player.position)).arg(Time.fromMs(player.duration))
        anchors.right: parent.right
        anchors.rightMargin: 80
        anchors.verticalCenter: parent.verticalCenter
    }
}
