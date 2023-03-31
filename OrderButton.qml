import QtQuick 2.15
import Qt.labs.settings

Rectangle {
    height: 20
    width: 20
    property int type: orderSettings.type
    Settings {
        id: orderSettings
        fileName: "settings.ini"
        category: ""
        property int type: 0
    }
    Component.onDestruction: {
        orderSettings.type = type;
    }
    Image {
        id: orderImg
        mipmap: true
        anchors.fill: parent
        source: {
            switch(parent.type) {
            case 0: orderArea.containsMouse || orderArea.pressed ? "qrc:/src/png/ordered-active.png" : "qrc:/src/png/ordered.png";break;
            case 1: orderArea.containsMouse || orderArea.pressed ? "qrc:/src/png/random-active.png" : "qrc:/src/png/random.png";break;
            case 2: orderArea.containsMouse || orderArea.pressed ? "qrc:/src/png/loop-active.png" : "qrc:/src/png/loop.png";break;
            }
        }
    }
    MouseArea {
        id: orderArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            orderImg.scale = 0.9;
        }
        onReleased: {
            orderImg.scale = 1;
        }
        onClicked: {
            parent.type = (parent.type + 1) % 3;
        }
    }
}
