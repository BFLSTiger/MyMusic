import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

Rectangle {
    width: parent.width
    property string source: settings.source
    property int listIndex: settings.listIndex
    property int songIndex: settings.songIndex
    property string songName: settings.songName
//    property var sequence: JSON.parse(settings.sequenceJSON)
    signal songChanged()
    Settings {
        id: settings
        location: "file:settings.ini"
        category: ""
        property string source: ""
        property int listIndex: -1
        property int songIndex: -1
        property string songName: ""
//        property string sequenceJSON: '[]'
        property string listsJSON: '[]'
    }
    Component.onDestruction: {
        settings.source = source;
        settings.listIndex = listIndex;
        settings.songIndex = songIndex;
        settings.songName = songName;
//        settings.sequenceJSON = JSON.stringify(sequence);
        var lists = [];
        for(var i = 1; i < listView.model.count; i++) {
            lists.push(listView.model.get(i));
        }
        settings.listsJSON = JSON.stringify(lists);
    }
    function nextSong() {
        if(songIndex != -1) {
            listView.itemAtIndex(listIndex).songs[songIndex]["playingStatus"] = false;
            if(listView.currentIndex === listIndex)
                songView.itemAtIndex(songIndex).isPlaying = false;
        }
        songIndex = (songIndex + 1) % listView.itemAtIndex(listIndex).songs.length;
        source = listView.itemAtIndex(listIndex).songs[songIndex]["songSource"];
        listView.itemAtIndex(listIndex).songs[songIndex]["playingStatus"] = true;
        if(listView.currentIndex === listIndex)
            songView.itemAtIndex(songIndex).isPlaying = true;
        songChanged();
    }
    function randSong() {
        if(songIndex != -1) {
            listView.itemAtIndex(listIndex).songs[songIndex]["playingStatus"] = false;
            if(listView.currentIndex === listIndex)
                songView.itemAtIndex(songIndex).isPlaying = false;
        }
        songIndex = Math.floor(Math.random()*listView.itemAtIndex(listIndex).songs.length);
        source = listView.itemAtIndex(listIndex).songs[songIndex]["songSource"];
        listView.itemAtIndex(listIndex).songs[songIndex]["playingStatus"] = true;
        if(listView.currentIndex === listIndex)
            songView.itemAtIndex(songIndex).isPlaying = true;
        songChanged();
    }
    onSongIndexChanged: {
        if(listIndex !== -1 && listView.itemAtIndex(listIndex)) {
            listView.itemAtIndex(listIndex).currentIndex = songIndex;
            songName = songIndex === -1 ? "" : listView.itemAtIndex(listIndex).songs[songIndex]["songName"];
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 15
        width: 180
        height: parent.height
        SongListDelegate {
            id: songListDelegate
        }
        SongListHeader {
            id: songListHeader
        }
        ListView {
            id: listView
            clip: true
            anchors.fill: parent
            spacing: 5
            header: songListHeader
            delegate: songListDelegate
            model: ListModel {
                ListElement {
                    coverImg: "qrc:/src/png/default.png"
                    listName: "默认歌单"
                    listInit: 0
                }
            }
            onCurrentItemChanged: {
                if(currentItem) {
                    songView.model.clear();
                    for(var i = 0; i < currentItem.songs.length; i++)
                        songView.model.append(currentItem.songs[i]);
                    songView.currentIndex = currentItem.currentIndex;
                }
            }
            Component.onCompleted: {
                player.source = body.source;
                var lists = JSON.parse(settings.listsJSON);
                for(var i = 0; i < lists.length; i++)
                    listView.model.append(lists[i]);
            }
        }
    }
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 15
        width: 800
        height: parent.height
        Rectangle {
            id: listInfo
            anchors.top: parent.top
            height: 180
            width: parent.width
            Row {
                leftPadding: 20
                spacing: 20
                Image {
                    id: coverImg
                    mipmap: true
                    source: listView.model.get(listView.currentIndex)["coverImg"]
                    height: 150
                    width: 150
                }
                Label {
                    id: listName
                    font.pixelSize: 24
                    text: listView.model.get(listView.currentIndex)["listName"]
                }
            }
        }
        SongDelegate {
            id: songDelegate
        }
        SongHeader {
            id: songHeader
        }
        ListView {
            id: songView
            anchors.top: listInfo.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            currentIndex: -1
            header: songHeader
            clip: true
            delegate: songDelegate
            model: ListModel {}
        }
    }
    SongListPopup {
        id: songListPopup
    }
    SongPopup {
        id: songPopup
    }
}
