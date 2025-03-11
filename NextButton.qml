import QtQuick

Rectangle {
    height: 20
    width: 20
    Image {
        id: nextImg
        anchors.fill: parent
        mipmap: true
        source: nextArea.containsMouse || nextArea.pressed ? "qrc:/src/png/next-active.png" : "qrc:/src/png/next.png"
    }
    MouseArea {
        id: nextArea
        anchors.fill: parent
        enabled: player.source == "" ? false : true
        hoverEnabled: player.source == "" ? false : true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.CustomCursor
        onPressed: {
            nextImg.scale = 0.9;
        }
        onReleased: {
            nextImg.scale = 1;
        }
        onClicked: {
            switch(player.type) {
            case 0: body.nextSong();break;
            case 1: body.randSong();break;
            case 2: body.nextSong();break;
            }
        }
    }
}
