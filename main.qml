import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia
import QtQuick.Controls
import Qt.labs.platform
import Qt.labs.settings
import QtQml

Window {
    id: mainWindow
    width: 1020
    height: 720
    visible: true
    title: qsTr("MyMusic")
    flags: Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowMinimizeButtonHint| Qt.Window
    color: "#00000000"
    MediaDevices {
        id: devices
    }
    MediaPlayer {
        id: player
        property int type
        audioOutput: AudioOutput {
            id: output
            device: devices.defaultAudioOutput
        }
        onMediaStatusChanged: {
            if(mediaStatus === MediaPlayer.EndOfMedia) {
                switch(type) {
                case 0: body.nextSong();break;
                case 1: body.randSong();break;
                }
            }
        }
        onTypeChanged: {
            if(type === 2) {
                loops = -1;
            }
            else {
                loops = 1;
            }
        }
    }
    Rectangle {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        id: mainRect
        color: "#00000000"
        Rectangle {
            height: 20
            width: parent.width-20
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 10
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#00000000"
                }
                GradientStop {
                    position: 1
                    color: "#2E000000"
                }
            }
        }
        Rectangle {
            height: 20
            width: parent.width-20
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 10
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#2E000000"
                }
                GradientStop {
                    position: 1
                    color: "#00000000"
                }
            }
        }
        Rectangle {
            width: 20
            height: parent.height-20
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            radius: 10
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop {
                    position: 0
                    color: "#00000000"
                }
                GradientStop {
                    position: 1
                    color: "#2E000000"
                }
            }
        }
        Rectangle {
            width: 20
            height: parent.height-20
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            radius: 10
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop {
                    position: 0
                    color: "#2E000000"
                }
                GradientStop {
                    position: 1
                    color: "#00000000"
                }
            }
        }
        Rectangle {
            clip: true
            width: parent.width - 20
            height: parent.height - 20
            anchors.centerIn: parent
            Header {
                id: header
            }
            Body {
                id: body
                anchors.top: header.bottom
                anchors.bottom: footer.top
                onSongChanged: {
                    player.stop();
                    player.source = source;
                    player.play();
                }
            }
            Footer {
                id: footer
            }
        }
    }
    SystemTrayIcon {
        tooltip: "MyMusic"
        visible: true
        icon.source: "qrc:/src/png/MusicLogo.png"
        menu: Menu {
            MenuItem {
                text: player.playbackState === MediaPlayer.PlayingState ? "暂停" : "播放"
                onTriggered: {
                    if(player.playbackState === MediaPlayer.PlayingState) {
                        player.pause();
                    }
                    else {
                        player.play();
                    }
                }
            }
            MenuItem {
                text: "退出"
                onTriggered: {
                    Qt.quit();
                }
            }
        }
        onActivated: (reason)=> {
            if(reason === SystemTrayIcon.Trigger) {
                mainRect.scale = 1;
                mainWindow.show();
                mainWindow.raise();
                mainWindow.requestActivate();
            }
        }
    }
    Settings {
        fileName: "settings.ini"
        category: ""
        property alias volume: output.volume
    }
    Shortcut {
        sequence: " "
        enabled: true
        onActivated: {
            if(player.playbackState === MediaPlayer.PlayingState)
                player.pause();
            else player.play();
        }
    }
}
