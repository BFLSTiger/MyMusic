import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

Popup {
    modal: Qt.ApplicationModal
    anchors.centerIn: parent
    closePolicy: Popup.CloseOnPressOutside
    focus: true
    height: 200
    width: 300
    clip: true
    property int type: 0
    property int index: -1
    property string listName: ""
    onOpened: {
        if(type) {
            nameInput.text = listName;
        }
        else {
            index = -1;
        }
    }
    Rectangle {
        anchors.fill: parent
        Label {
            text: type ? "重命名歌单" : "添加歌单"
            font.pixelSize: 14
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5
        }
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 30
            anchors.bottom: warningLabel.top
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "歌单名称"
            }
            TextField {
                id: nameInput
                background: Rectangle {
                    border.color: "#35C1FF"
                }
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 25
                font.pixelSize: 12
                implicitWidth: 180
            }
        }
        Label {
            id: warningLabel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: popupButton.top
            anchors.bottomMargin: 20
            color: "red"
        }
        Button {
            id: popupButton
            text: type? "重命名" : "添加"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            implicitWidth: 50
            implicitHeight: 30
            onClicked: {
                if(nameInput.text.length) {
                    for(var i = 0; i < listView.model.count; i++) {
                        if(i !== songListPopup.index && nameInput.text === listView.model.get(i)["listName"]) {
                            warningLabel.text = "已存在该歌单";
                            return;
                        }
                    }
                    var listInfo = {
                        "listName": nameInput.text,
                        "coverImg": "qrc:/src/png/default.png",
                        "listInit": songListPopup.type ^ 1
                    };
                    if(songListPopup.type) {
                        listView.model.set(songListPopup.index,listInfo);
                    }
                    else {
                        listView.model.append(listInfo);
                    }
                    songListPopup.close();
                }
                else {
                    warningLabel.text = "歌单名称不能为空";
                }
            }
        }
        onVisibleChanged: {
            nameInput.clear();
            warningLabel.text = "";
        }
        Shortcut {
            enabled: songListPopup.visible
            sequence: "Return"
            onActivated: {
                popupButton.clicked();
            }
        }
    }
}
