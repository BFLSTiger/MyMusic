import QtQuick 2.15
import QtQuick.Controls

Component {
    Rectangle {
        width: 800
        height: 20
        Row {
            anchors.fill: parent
            Label {
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 10
                width: 400
                color: "#A7A7A7"
                text: "歌曲"
            }
            Label {
                anchors.verticalCenter: parent.verticalCenter
                width: 300
                color: "#A7A7A7"
                leftPadding: 20
                text: "歌手"
            }
            Label {
                anchors.verticalCenter: parent.verticalCenter
                width: 80
                color: "#A7A7A7"
                text: "时长"
            }
            Rectangle {
                width: 20
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    height: 15
                    width: 15
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    source: addSongArea.containsMouse || addSongArea.pressed ? "qrc:/src/png/add-active.png" : "qrc:/src/png/add.png"
                }
                MouseArea {
                    id: addSongArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        songPopup.type = 0;
                        songPopup.open(mainRect.Center);
                    }
                }
            }
        }
    }
}
