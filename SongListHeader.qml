import QtQuick 2.15
import QtQuick.Controls

Component {
    Rectangle {
        width: 155
        height: 20
        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: "歌单"
        }
        Rectangle {
            width: 20
            height: parent.height
            anchors.right: parent.right
            Image {
                id: addListImg
                height: 15
                width: 15
                mipmap: true
                anchors.verticalCenter: parent.verticalCenter
                source: addListArea.containsMouse || addListArea.pressed ? "qrc:/src/png/add-active.png" : "qrc:/src/png/add.png"
            }
            MouseArea {
                id: addListArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: {
                    addListImg.scale = 0.9;
                }
                onReleased: {
                    addListImg.scale = 1;
                }
                onClicked: {
                    songListPopup.type = 0;
                    songListPopup.open();
                }
            }
        }
    }
}

