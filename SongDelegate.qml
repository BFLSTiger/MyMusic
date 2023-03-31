import QtQuick 2.15
import QtQuick.Controls
import QtMultimedia
import QtQuick.Layouts
import "src/js/time.js" as Time

Component {
    Rectangle {
        id: song
        width: ListView.view.width
        height: isPlaying ? 60 : 50
        color: ListView.isCurrentItem || isPlaying ? "#E3E3E3" : "#FFFFFF"
        property bool isPlaying: playingStatus
        property bool valid: true
        MediaPlayer {
            id: songPlayer
            source: songSource
            audioOutput: AudioOutput{}
            onErrorOccurred: function(error) {
                if(error === MediaPlayer.ResourceError) {
                    valid = false;
                }
            }
        }
        Row {
            anchors.fill: parent
            Label {
                id: name
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 10
                text: songName
                elide: Text.ElideRight
                width: 400
                color: valid ? (isPlaying ? "#35C1FF" : "#000000") : "#FF0000"
            }
            Label {
                id: singer
                anchors.verticalCenter: parent.verticalCenter
                text: songSinger
                elide: Text.ElideRight
                leftPadding: 20
                width: 300
                color: valid ? (isPlaying ? "#35C1FF" : "#000000") : "#FF0000"
            }
            Label {
                id: duration
                anchors.verticalCenter: parent.verticalCenter
                rightPadding: 10
                width: 100
                text: Time.fromMs(songPlayer.duration)
                elide: Text.ElideRight
                color: valid ? (isPlaying ? "#35C1FF" : "#000000") : "#FF0000"
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse)=> {
                if(mouse.button === Qt.LeftButton) {
                    song.ListView.view.currentIndex = index;
                }
                else {
                    songMenu.popup();
                }
            }
            onDoubleClicked: (mouse)=> {
                if(mouse.button === Qt.LeftButton) {
                    if(body.songIndex != -1) {
                        listView.itemAtIndex(body.listIndex).songs[body.songIndex]["playingStatus"] = false;
                        if(listView.currentIndex === body.listIndex)
                            song.ListView.view.itemAtIndex(body.songIndex).isPlaying = 0;
                    }
                    body.source = songPlayer.source;
                    body.listIndex = listView.currentIndex;
                    body.songIndex = index;
                    listView.itemAtIndex(body.listIndex).songs[body.songIndex]["playingStatus"] = true;
                    song.isPlaying = 1;
                    songChanged();
                }
            }
        }
        Menu {
            id: songMenu
            MenuItem {
                text: "修改歌曲信息"
                onTriggered: {
                    songPopup.type = 1;
                    songPopup.index = index;
                    songPopup.songName = songName;
                    songPopup.songSinger = songSinger;
                    songPopup.songUrl = songSource;
                    songPopup.open(mainRect.Center);
                }
            }
            MenuItem {
                text: "删除歌曲"
                onTriggered: {
                    if(body.listIndex === listView.currentIndex && body.songIndex === index) {
                        if(songView.count === 1) {
                            body.songIndex = -1;
                            body.source = "";
                            body.songChanged();
                        }
                        else {
                            body.nextSong();
                        }
                    }
                    listView.currentItem.songs.splice(index,1);
                    songView.model.remove(index);
                    listView.currentItem.size = listView.currentItem.songs.length;
                }
            }
        }
    }
}
