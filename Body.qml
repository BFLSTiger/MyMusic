import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

Rectangle {
    width: parent.width
    property string source: memory.source
    property int listIndex: memory.listIndex
    property int songIndex: memory.songIndex
    property string songName: memory.songName
    signal songChanged()
    Settings {
        id: memory
        location: "file:memory.ini"
        category: ""
        property string source: ""
        property int listIndex: -1
        property int songIndex: -1
        property string songName: ""
        property string listsJSON: '[]'
    }
    Component.onDestruction: {
        memory.source = source;
        memory.listIndex = listIndex;
        memory.songIndex = songIndex;
        memory.songName = songName;
        var lists = [];
        for(var i = 1; i < listView.model.count; i++) {
            lists.push(listView.model.get(i));
        }
        memory.listsJSON = JSON.stringify(lists);
    }
    function nextSong() {
        if(songIndex != -1) {
            listView.itemAtIndex(listIndex).songs[songIndex]["playingStatus"] = false;
            if(listView.currentIndex === listIndex)
            {
                songView.itemAtIndex(songIndex).isPlaying = false;
                songModel.get(songIndex)["playingStatus"] = false;
            }
        }
        songIndex = (songIndex + 1) % listView.itemAtIndex(listIndex).songs.length;
        source = listView.itemAtIndex(listIndex).songs[songIndex]["songSource"];
        listView.itemAtIndex(listIndex).songs[songIndex]["playingStatus"] = true;
        if(listView.currentIndex === listIndex)
        {
            songView.itemAtIndex(songIndex).isPlaying = true;
            songModel.get(songIndex)["playingStatus"] = true;
        }
        songChanged();
    }
    function randSong() {
        if(songIndex != -1) {
            listView.itemAtIndex(listIndex).songs[songIndex]["playingStatus"] = false;
            if(listView.currentIndex === listIndex)
            {
                songView.itemAtIndex(songIndex).isPlaying = false;
                songModel.get(songIndex)["playingStatus"] = false;
            }
        }
        var step = Math.floor(Math.random()*(listView.itemAtIndex(listIndex).songs.length - 1));
        songIndex = (songIndex + step) % listView.itemAtIndex(listIndex).songs.length;
        source = listView.itemAtIndex(listIndex).songs[songIndex]["songSource"];
        listView.itemAtIndex(listIndex).songs[songIndex]["playingStatus"] = true;
        if(listView.currentIndex === listIndex)
        {
            songView.itemAtIndex(songIndex).isPlaying = true;
            songModel.get(songIndex)["playingStatus"] = true;
        }
        songChanged();
    }
    onSongChanged: {
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
            property int dragItemIndex: -1
            model: ListModel {
                id: listModel
                ListElement {
                    coverImg: "qrc:/src/png/default.png"
                    listName: "默认歌单"
                    listInit: 0
                }
            }
            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
            DropArea {
                anchors.fill: parent
                onDropped: function(mouse) {
                    var headerHeight = 20;
                    var nextY = parent.visibleArea.yPosition * parent.contentHeight + mouse.y - headerHeight;
                    if(nextY < 0)nextY = 0;
                    if(nextY >= parent.contentHeight - 20) nextY = parent.contentHeight - headerHeight - 1;
                    var nextIndex = Math.floor(nextY / 45);
                    if(nextIndex === 0)nextIndex = 1;
                    if(nextIndex !== -1 && nextIndex !== parent.dragItemIndex)
                    {
                        if(nextIndex > parent.dragItemIndex)
                            listModel.move(parent.dragItemIndex + 1,parent.dragItemIndex,nextIndex - parent.dragItemIndex);
                        else
                            listModel.move(nextIndex,nextIndex + 1,parent.dragItemIndex - nextIndex);
                        if(body.listIndex === parent.dragItemIndex)
                            body.listIndex = nextIndex;
                        else
                        {
                            if(body.listIndex > parent.dragItemIndex && body.listIndex <= nextIndex)
                                body.listIndex--;
                            else if(body.listIndex < parent.dragItemIndex && body.listIndex >= nextIndex)
                                body.listIndex++;
                        }
                    }
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
                var lists = JSON.parse(memory.listsJSON);
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
            property int dragItemIndex: -1
            header: songHeader
            clip: true
            delegate: songDelegate
            model: ListModel {
                id: songModel
            }
            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
            DropArea {
                anchors.fill: parent
                onDropped: function(drop) {
                    var headerHeight = 20;
                    var nextY = parent.visibleArea.yPosition * parent.contentHeight + drop.y - headerHeight;
                    if(nextY < 0)nextY = 0;
                    if(nextY >= parent.contentHeight - 20) nextY = parent.contentHeight - headerHeight - 1;
                    var nextIndex = Math.floor(nextY / 50);
                    if(listIndex === listView.currentIndex && (songIndex + 1) * 50 <= nextY)
                        nextIndex = Math.floor((nextY - 10) / 50);
                    if(nextIndex !== -1 && nextIndex !== parent.dragItemIndex)
                    {
                        if(nextIndex > parent.dragItemIndex)
                            songModel.move(parent.dragItemIndex + 1,parent.dragItemIndex,nextIndex - parent.dragItemIndex);
                        else
                            songModel.move(nextIndex,nextIndex + 1,parent.dragItemIndex - nextIndex);
                        listView.currentItem.songs = [];
                        for(var i = 0; i < songView.count; i++)
                        {
                            var songInfo = {
                                "songName": songModel.get(i)["songName"],
                                "songSinger": songModel.get(i)["songSinger"],
                                "songSource": songModel.get(i)["songSource"],
                                "playingStatus": songModel.get(i)["playingStatus"],
                            };
                            listView.currentItem.songs.push(songInfo);
                            if(listView.currentItem.songs[i]["playingStatus"] === true)
                                songIndex = i;
                        }
                        listView.currentItem.size = listView.currentItem.songs.length;
                    }
                }
            }
            onCurrentIndexChanged: {
                listView.currentItem.currentIndex = currentIndex;
            }
        }
    }
    SongListPopup {
        id: songListPopup
    }
    SongPopup {
        id: songPopup
    }
}
