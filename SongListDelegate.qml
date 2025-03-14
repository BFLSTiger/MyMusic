import QtQuick
import QtQuick.Controls
import QtCore

Component {
    Rectangle {
        clip: true
        id: songList
        width: 155
        height: 40
        radius: 5
        color: ListView.isCurrentItem ? "#E3E3E3" : "#FFFFFF"
        property var songs: JSON.parse(listMemory.songsJSON)
        property int size: songs.length
        property int currentIndex: listMemory.currentIndex
        Settings {
            id: listMemory
            location: "file:memory.ini"
            category: listName
            property int currentIndex: -1
            property string songsJSON: '[]'
        }
        Component.onCompleted: {
            if(listInit) {
                songs = [];
                size = 0;
                currentIndex = -1;
                listInit = 0;
            }
        }

        Component.onDestruction: {
            listMemory.currentIndex = currentIndex;
            listMemory.songsJSON = JSON.stringify(songs);
        }
        Row {
            leftPadding: 10
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter
            Image {
                width: 32
                height: 32
                mipmap: true
                source: coverImg
            }
            Column {
                Label {
                    text: listName
                    elide: Text.ElideRight
                    font.pixelSize: 12
                    font.bold: songList.ListView.isCurrentItem ? true : false;
                }
                Label {
                    text: songList.size+"首"
                }
            }
        }
        MouseArea {
            id: songListMouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onEntered: {
                parent.color = songList.ListView.isCurrentItem ? "#E3E3E3" : "#EBEBEB";
            }
            onExited: {
                parent.color = songList.ListView.isCurrentItem ? "#E3E3E3" : "#FFFFFF";
            }
            onClicked: (mouse)=> {
                if(mouse.button === Qt.LeftButton) {
                    if(songList.ListView.view.currentIndex !== -1)
                        songList.ListView.view.currentItem.color = "#FFFFFF";
                    songList.ListView.view.currentIndex = index;
                    songList.ListView.view.currentItem.color = "#E3E3E3";
                }
                if(mouse.button === Qt.RightButton) {
                    listMenu.popup();
                }
            }
            onDoubleClicked: {
                if(body.songIndex !== -1) {
                    listView.itemAtIndex(body.listIndex).songs[body.songIndex]["playingStatus"] = false;
                }
                body.listIndex = index;
                if(songList.songs.length) {
                    body.songIndex = 0;
                    body.source = songList.songs[0]["songSource"];
                    songList.songs[0]["playingStatus"] = true;
                    songModel.get(0)["playingStatus"] = true;
                    songView.itemAtIndex(0).isPlaying = true;
                }
                else {
                    body.songIndex = -1;
                    body.source = "";
                }
                body.songChanged();
            }
            Menu {
                id: listMenu
                MenuItem {
                    text: "重命名"
                    enabled: index === 0 ? false : true
                    onTriggered: {
                        songListPopup.type = 1;
                        songListPopup.index = index;
                        songListPopup.listName = listName;
                        songListPopup.open();
                    }
                }
               // MenuItem {
               //     text: "更改图标"
               // }
                MenuItem {
                    text: "删除歌单"
                    enabled: index === 0 ? false : true
                    onTriggered: {
                        songList.currentIndex = -1;
                        songList.songs = [];
                        var tmpindex = index;
                        listView.model.remove(index);
                        if(body.listIndex === tmpindex) {
                            body.listIndex = 0;
                            body.songIndex = -1;
                            body.source = "";
                            body.songChanged();
                        }
                    }
                }
            }
            drag.target: index ? songList : null
            drag.axis: Drag.YAxis
            drag.onActiveChanged: {
                if(drag.active)
                {
                    songList.z = 2;
                    listView.dragItemIndex = index;
                }
                else
                {
                    songList.z = 1;
                }
                songList.Drag.drop();
            }
        }
        Drag.active: songListMouseArea.drag.active
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2
        states: State {
            when: songListMouseArea.drag.active
            ParentChange {
                target: songList
                parent: listView.parent
            }
        }
    }
}
