import QtQuick
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
    property string songName: ""
    property string songSinger: ""
    property string songUrl: ""
    onOpened: {
        if(type) {
            nameInput.text = songName;
            singerInput.text = songSinger;
            urlInput.text = songUrl;
        }
        else {
            index = -1;
        }
    }
    Rectangle {
        anchors.fill: parent
        Label {
            text: type ? "修改歌曲信息" : "添加歌曲"
            font.pixelSize: 14
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5
        }
        GridLayout {
            anchors.fill: parent
            anchors.topMargin: 30
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 30
            columns: 3
            rows: 5
            Label {
                Layout.row: 0
                Layout.column: 0
                Layout.alignment: Qt.AlignHCenter
                text: "曲名"
            }
            TextField {
                id: nameInput
                background: Rectangle {
                    border.color: "#35C1FF"
                }
                Layout.row: 0
                Layout.column: 1
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 25
                font.pixelSize: 12
                implicitWidth: 180
            }
            Label {
                Layout.row: 1
                Layout.column: 0
                Layout.alignment: Qt.AlignHCenter
                text: "歌手"
            }
            TextField {
                id: singerInput
                background: Rectangle {
                    border.color: "#35C1FF"
                }
                Layout.row: 1
                Layout.column: 1
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 25
                font.pixelSize: 12
                implicitWidth: 180
            }
            Label {
                Layout.row: 2
                Layout.column: 0
                Layout.alignment: Qt.AlignHCenter
                text: "位置"
            }
            TextField {
                id: urlInput
                background: Rectangle {
                    border.color: "#35C1FF"
                }
                readOnly: true
                Layout.row: 2
                Layout.column: 1
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 25
                font.pixelSize: 12
                implicitWidth: 180
            }
            Button {
                text: "浏览"
                Layout.row: 2
                Layout.column: 2
                implicitWidth: 50
                implicitHeight: 25
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    fileDialog.open();
                }
            }
            Label {
                id: warningLabel
                Layout.row: 3
                Layout.column: 1
                Layout.alignment: Qt.AlignHCenter
                color: "red"
            }

            Button {
                id: popupButton
                text: type ? "修改" : "添加"
                Layout.row: 4
                Layout.column: 1
                implicitWidth: 50
                implicitHeight: 30
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    if(urlInput.text.length) {
                        for(var i = 0; i < listView.currentItem.songs.length; i++)
                            if(i !== songPopup.index  && listView.currentItem.songs[i]["songSource"] === urlInput.text) {
                                warningLabel.text = "歌单中已存在该歌曲";
                                return;
                            }
                        var songInfo = {
                            "songName": nameInput.text,
                            "songSinger": singerInput.text,
                            "songSource": urlInput.text,
                            "playingStatus": false,
                        };
                        if (songPopup.type) {
                            songInfo["playingStatus"] = body.listIndex === listView.currentIndex && body.songIndex === songPopup.index;
                            listView.currentItem.songs[songPopup.index] = songInfo;
                            songView.model.set(songPopup.index,songInfo);
                        }
                        else {
                            listView.currentItem.songs.push(songInfo);
                            songView.model.append(songInfo);
                            if(body.listIndex === listView.currentIndex && body.songIndex === songPopup.index) {
                                body.songName = nameInput.text;
                            }
                        }
                        listView.currentItem.size = listView.currentItem.songs.length;
                        songPopup.close();
                    }
                    else {
                        warningLabel.text = "位置不能为空"
                    }
                }
            }
            onVisibleChanged: {
                nameInput.clear();
                singerInput.clear();
                urlInput.clear();
                warningLabel.text = "";
            }
            Shortcut {
                enabled: songPopup.visible
                sequence: "Return"
                onActivated: {
                    popupButton.clicked();
                }
            }
        }
    }
    FileDialog {
        id: fileDialog
        onAccepted: {
            var filename = selectedFile.toString().substring(currentFolder.toString().length+1).split(".");
            filename.pop();
            filename = filename.join('.');
            filename = filename.split("-");
            var singer ,name;
            if(filename.length>1) {
                singer = filename[0].trim();
                name = filename.slice(1).join("-").trim();
            }
            else {
                singer = "";
                name = filename.join("-").trim();
            }
            if(songPopup.type === 0 || nameInput.text.length === 0) {
                nameInput.text = name;
            }
            if(songPopup.type === 0 || singerInput.text.length === 0) {
                singerInput.text = singer;
            }
            urlInput.text = selectedFile.toString().substring(8);
        }
    }
}
