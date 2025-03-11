import QtQuick

Rectangle {
    width: parent.width
    height: 60
    anchors.top: parent.top
    Rectangle {
        id: closeButton
        height: 25
        width: 25
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 15
        anchors.rightMargin: 15
        Image {
            id: closeButtonImg
            source: closeButtonArea.containsMouse || closeButtonArea.pressed ? "qrc:/src/png/close-active.png" : "qrc:/src/png/close.png"
            mipmap: true
            anchors.fill: parent
        }

        MouseArea {
            id: closeButtonArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: {
                closeButtonImg.scale = 0.9;
            }
            onReleased: {
                closeButtonImg.scale = 1;
            }
            onClicked: {
                windowHide.start();
            }
        }
    }
    MouseArea {
        z: -1
        anchors.fill: parent
        onPressed: {
            mainWindow.startSystemMove();
        }
    }

    ScaleAnimator {
        id: windowHide
        target: mainRect
        from: 1
        to: 0
        duration: 150
        running: false
        onFinished: {
            mainWindow.hide();
        }
    }
}
