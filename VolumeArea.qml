import QtQuick
import QtMultimedia
Rectangle {
    height: 40
    width: 180
    color: "#00000000"
    MySlider {
        id: volumeSlider
        width: 0
        value: output.volume
        onMoved: {
            output.volume = value;
            volumeButton.volumesaved = output.volume ? output.volume : 0.01;
        }
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: volumeButton.right
        anchors.leftMargin: 10
    }
    Rectangle {
        id: volumeButton
        width: 20
        height: 20
        color: "#00000000"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        property double volumesaved: 1
        Image {
            id: volumeButtonImg
            mipmap: true
            width: 20
            height: 20
            source: output.volume ? (volumeButtonArea.containsMouse || volumeButtonArea.pressed ? "qrc:/src/png/voice-active.png" : "qrc:/src/png/voice.png")
                                  : (volumeButtonArea.containsMouse || volumeButtonArea.pressed ? "qrc:/src/png/silent-active.png" : "qrc:/src/png/silent.png")
        }
        NumberAnimation {
            target: volumeSlider
            property: "width"
            id: volumeShow
            from: volumeSlider.width
            to: 100
            duration: 150
            running: false
        }
        NumberAnimation {
            target: volumeSlider
            property: "width"
            id:volumeHide
            from: volumeSlider.width
            to: 0
            duration: 150
            running: false
        }
        MouseArea {
            id: volumeButtonArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: {
                volumeButtonImg.scale = 0.9;
            }
            onReleased: {
                volumeButtonImg.scale = 1;
                if(output.volume)
                    output.volume = 0;
                else output.volume = parent.volumesaved;
            }
            onEntered: {
                if(!volumeSlider.width) {
                    volumeShow.start();
                }
            }
        }
    }
    MouseArea {
        z: -1
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true
        id: volumeMouseArea
        enabled: true
        anchors.fill: parent
        hoverEnabled: true
        onExited: {
            if(volumeButtonArea.containsMouse || volumeSlider.hovered)
                return;
            volumeHide.start();
        }
    }
}
