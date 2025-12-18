import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: root

    // Colors
    property color colorFg: "#a7a7a7"
    property color colorBg: "#202020"
    property color color0: "#2d2d2d"
    property color color8: "#605f61"
    property color color1: "#9d5b61"
    property color color9: "#9d5b61"
    property color color2: "#838d69"
    property color color10: "#838b69"
    property color color3: "#b38d6a"
    property color color11: "#b38d6a"
    property color color4: "#606d84"
    property color color12: "#606d84"
    property color color5: "#766577"
    property color color13: "#766577"
    property color color6: "#808fa0"
    property color color14: "#808fa0"
    property color color7: "#9c9a9a"
    property color color15: "#9c9a9a"

    // Fonts
    property string fontFamily: "Inter"
    property int fontSize: 20

    // Icons
    property list<string> icons: ["", "", "", "", "ﱘ", "", "", "", "", "睊", "直", "", "墳", "鈴", "凌", "﫼", "", "襤", "", ""]

    // Commands
    property list<string> launcherCmd: ["rofi", "-show", "drun"]
    property list<string> volumeCmd: ["pavucontrol"]
    property list<string> suspendCmd: ["swaylock", "-f", "-c", "000000"]
    property list<string> rebootCmd: ["swaylock", "-f", "-c", "000000"]
    property list<string> logoutCmd: ["swaylock", "-f", "-c", "000000"]
    property list<string> lockCmd: ["swaylock", "-f", "-c", "000000"]
    property list<string> poweroffCmd: ["swaylock", "-f", "-c", "000000"]

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    implicitWidth: 48
    color: colorBg

    // Launcher
    Text {
        id: launcher
        text: icons[6]
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        color: color6
        font {
            family: fontFamily
            pixelSize: fontSize
        }
        MouseArea {
            anchors.fill: parent
            onClicked: Quickshell.execDetached(launcherCmd)
        }
    }

    // Workspaces
    Rectangle {
        radius: 5
        Layout.fillWidth: true
        height: childrenRect.height
        color: color0
        anchors.top: launcher.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 4
        anchors.topMargin: 10
        Column {
            padding: 5
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: 6
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    text: icons[index]
                    color: isActive ? colorFg : (ws ? colorFg : color8)
                    font {
                        family: fontFamily
                        pixelSize: fontSize
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    }
                }
            }
        }
    }

    // Tray
    Rectangle {
        id: tray
        radius: 5
        Layout.fillWidth: true
        height: childrenRect.height
        color: color0
        anchors.bottom: clock.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 4
        anchors.bottomMargin: 10
        Column {
            padding: 5
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: battery
                text: icons[8]
                anchors.horizontalCenter: parent.horizontalCenter
                color: color4
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                MouseArea {
                    anchors.fill: parent
                    //onClicked: Quickshell.execDetached(suspendCmd)
                }
            }

            Text {
                id: wifi
                text: icons[10]
                anchors.horizontalCenter: parent.horizontalCenter
                color: color5
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                MouseArea {
                    anchors.fill: parent
                    //onClicked: Quickshell.execDetached(suspendCmd)
                }
            }

            Text {
                id: brightness
                text: icons[11]
                anchors.horizontalCenter: parent.horizontalCenter
                color: color3
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                MouseArea {
                    anchors.fill: parent
                    //onClicked: Quickshell.execDetached(suspendCmd)
                }
            }

            Text {
                id: volume
                text: icons[12]
                anchors.horizontalCenter: parent.horizontalCenter
                color: color2
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(volumeCmd)
                }
            }
        }
    }

    // Clock
    Rectangle {
        id: clock
        radius: 5
        Layout.fillWidth: true
        height: childrenRect.height
        color: color0
        anchors.bottom: powermenu.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 4
        anchors.bottomMargin: 5
        Column {
            padding: 5
            spacing: 0
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: hour
                anchors.horizontalCenter: parent.horizontalCenter
                color: colorFg
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                text: Qt.formatDateTime(new Date(), "HH")
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: hour.text = Qt.formatDateTime(new Date(), "HH")
                }
            }

            Text {
                id: minute
                color: colorFg
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                text: Qt.formatDateTime(new Date(), "mm")
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: minute.text = Qt.formatDateTime(new Date(), "mm")
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                calendar.visible ? calendar.visible = false : calendar.visible = true;
                grid.month = Qt.formatDateTime(new Date(), "M") - 1;
                grid.year = Qt.formatDateTime(new Date(), "yyyy");
                grid.year++;
                grid.year--;
            }
        }
    }

    // Power Menu
    Column {
        id: powermenu
        padding: 5
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5

        HoverHandler {
            id: hoverHandler
        }

        Text {
            id: suspend
            visible: hoverHandler.hovered ? true : false
            text: icons[13]
            anchors.horizontalCenter: parent.horizontalCenter
            color: color2
            font {
                family: fontFamily
                pixelSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(suspendCmd)
            }
        }

        Text {
            id: reboot
            visible: hoverHandler.hovered ? true : false
            text: icons[14]
            anchors.horizontalCenter: parent.horizontalCenter
            color: color3
            font {
                family: fontFamily
                pixelSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(rebootCmd)
            }
        }

        Text {
            id: logout
            visible: hoverHandler.hovered ? true : false
            text: icons[15]
            anchors.horizontalCenter: parent.horizontalCenter
            color: color5
            font {
                family: fontFamily
                pixelSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(logoutCmd)
            }
        }

        Text {
            id: lock
            visible: hoverHandler.hovered ? true : false
            text: icons[16]
            anchors.horizontalCenter: parent.horizontalCenter
            color: color4
            font {
                family: fontFamily
                pixelSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(lockCmd)
            }
        }

        Text {
            id: poweroff
            text: icons[17]
            anchors.horizontalCenter: parent.horizontalCenter
            color: color1
            font {
                family: fontFamily
                pixelSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(poweroffCmd)
            }
        }
    }

    // Calendar
    PopupWindow {
        id: calendar
        anchor.window: root
        anchor.rect.x: parentWindow.width + 20
        anchor.rect.y: parentWindow.height - height - 20
        implicitWidth: 400
        implicitHeight: 325
        visible: false
        color: colorBg

        property list<string> months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

        Text {
            id: lastMonth
            anchors.right: month.left
            anchors.verticalCenter: month.verticalCenter
            anchors.rightMargin: 5
            color: color6
            font {
                family: fontFamily
                pixelSize: 12
                bold: true
            }
            text: icons[18]
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    grid.month === 0 ? grid.year-- : grid.year;
                    grid.month === 0 ? grid.month = 11 : grid.month--;
                }
            }
        }

        Text {
            id: month
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 30
            anchors.leftMargin: 40
            color: color1
            font {
                family: fontFamily
                pixelSize: fontSize
            }
            text: calendar.months[grid.month]
        }

        Text {
            id: nextMonth
            anchors.left: month.right
            anchors.verticalCenter: month.verticalCenter
            anchors.leftMargin: 5
            color: color6
            font {
                family: fontFamily
                pixelSize: 12
                bold: true
            }
            text: icons[19]
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    grid.month === 11 ? grid.year++ : grid.year;
                    grid.month === 11 ? grid.month = 0 : grid.month++;
                }
            }
        }

        Text {
            id: lastYear
            anchors.right: year.left
            anchors.verticalCenter: year.verticalCenter
            anchors.rightMargin: 5
            color: color6
            font {
                family: fontFamily
                pixelSize: 12
                bold: true
            }
            text: icons[18]
            MouseArea {
                anchors.fill: parent
                onClicked: grid.year--
            }
        }

        Text {
            id: year
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 30
            anchors.rightMargin: 40
            color: color1
            font {
                family: fontFamily
                pixelSize: fontSize
            }
            text: grid.year
        }

        Text {
            id: nextYear
            anchors.left: year.right
            anchors.verticalCenter: year.verticalCenter
            anchors.leftMargin: 5
            color: color6
            font {
                family: fontFamily
                pixelSize: 12
                bold: true
            }
            text: icons[19]
            MouseArea {
                anchors.fill: parent
                onClicked: grid.year++
            }
        }

        DayOfWeekRow {
            id: day
            anchors.top: year.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 15
            locale: grid.locale
            Layout.fillWidth: true
            leftPadding: 25
            rightPadding: 25
            delegate: Text {
                text: shortName
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                color: color6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                required property string shortName
            }
        }

        MonthGrid {
            id: grid
            anchors.top: day.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            locale: Qt.locale("en_US")
            Layout.fillWidth: true
            leftPadding: 25
            rightPadding: 25
            delegate: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: model.day
                font {
                    family: fontFamily
                    pixelSize: fontSize
                }
                color: model.today ? color1 : (model.month === grid.month ? colorFg : color8)
                required property var model
            }
        }
    }
}
