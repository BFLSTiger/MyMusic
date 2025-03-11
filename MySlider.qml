import QtQuick
import QtQuick.Controls

Slider {
    height: 4
    width: 100
    hoverEnabled: true
    focusPolicy: Qt.NoFocus
    handle: Rectangle {
        color: parent.pressed ? "#2DA4D9" : "#35C1FF"
        x: parent.position * parent.width - width / 2
        anchors.verticalCenter: parent.verticalCenter
        width: parent.hovered || parent.pressed ? 10 : 0
        height: parent.hovered || parent.pressed ? 10 : 0
        radius: height / 2
    }
    background: Rectangle {
        anchors.fill: parent
        radius: parent.height / 2
        color: "#EBEBEB"
        Rectangle {
            width: parent.parent.position * parent.parent.width
            height: parent.height
            radius: parent.radius
            color: "#35C1FF"
        }
    }
    MouseArea {
        z: -1
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
    }
}
