import QtQuick
import QtQuick.Controls
import GameOfLife_UI
import QtQuick.Studio.DesignEffects

Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height
    color: "#2c2c2c"
    radius: 0
    focus: true
    antialiasing: true

    property real gridSize: 500

    Text {
        id: titleText
        text: qsTr("Game of Life")
        color: "white"
        font.pixelSize: 48
        font.bold: true
        anchors {
            top: parent.top
            topMargin: 40
            horizontalCenter: parent.horizontalCenter
        }
    }

    Column {
        id: controls
        anchors.leftMargin: 139
        anchors.topMargin: 263
        anchors {
            left: parent.left
            top: titleText.bottom
            margins: 40
        }
        spacing: 20

        Text {
            height: 34
            text: qsTr("No. of rows: ") + rowSlider.value
            color: "white"
            font.pixelSize: 28
            font.family: "Arial"
        }

        Slider {
            id: rowSlider
            width: 425
            height: 50
            value: gamecontroller.rows
            from: 10
            to: 50
            stepSize: 1

            background: Rectangle {
                x: rowSlider.leftPadding
                y: rowSlider.topPadding + rowSlider.availableHeight / 2 - height / 2
                width: rowSlider.availableWidth
                height: 8
                radius: 4
                color: "#21be2b"

                Rectangle {
                    width: rowSlider.visualPosition * parent.width
                    height: parent.height
                    color: "#1db954"
                    radius: 4
                }
            }

            handle: Rectangle {
                x: rowSlider.leftPadding + rowSlider.visualPosition
                   * (rowSlider.availableWidth - width)
                y: rowSlider.topPadding + rowSlider.availableHeight / 2 - height / 2
                width: 32
                height: 32
                radius: 16
                color: rowSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }
        }

        Connections {
            target: rowSlider
            function onValueChanged() {
                gamecontroller.rows = Math.round(rowSlider.value)
            }
        }

        Text {
            height: 34
            text: qsTr("No. of columns: ") + columnSlider.value
            color: "white"
            font.pixelSize: 28
            font.family: "Arial"
        }

        Slider {
            id: columnSlider
            width: 425
            height: 50
            value: gamecontroller.columns
            from: 10
            to: 50
            stepSize: 1

            background: Rectangle {
                x: columnSlider.leftPadding
                y: columnSlider.topPadding + columnSlider.availableHeight / 2 - height / 2
                width: columnSlider.availableWidth
                height: 8
                radius: 4
                color: "#21be2b"

                Rectangle {
                    width: columnSlider.visualPosition * parent.width
                    height: parent.height
                    color: "#1db954"
                    radius: 4
                }
            }

            handle: Rectangle {
                x: columnSlider.leftPadding + columnSlider.visualPosition
                   * (columnSlider.availableWidth - width)
                y: columnSlider.topPadding + columnSlider.availableHeight / 2 - height / 2
                width: 32
                height: 32
                radius: 16
                color: columnSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }
        }

        Connections {
            target: columnSlider
            function onValueChanged() {
                gamecontroller.columns = Math.round(columnSlider.value)
            }
        }

        Row {
            spacing: 20
            padding: 10

            Button {
                id: startButton
                text: "Start"
                width: 120
                height: 40

                background: Rectangle {
                    color: startButton.pressed ? "#15883e" : "#1db954"
                    radius: 8
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Connections {
                target: startButton
                function onClicked() {
                    gamecontroller.startGame()
                }
            }

            Button {
                id: stopButton
                text: "Stop"
                width: 120
                height: 40

                background: Rectangle {
                    color: stopButton.pressed ? "#cc2222" : "#ff2828"
                    radius: 8
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Connections {
                target: stopButton
                function onClicked() {
                    gamecontroller.stopGame()
                }
            }

            Button {
                id: clearButton
                text: "Clear"
                width: 120
                height: 40

                background: Rectangle {
                    color: clearButton.pressed ? "#666666" : "#808080"
                    radius: 8
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Connections {
                target: clearButton
                function onClicked() {
                    gamecontroller.clearGame()
                }
            }
        }
    }

    Grid {
        id: gameGrid
        width: 750
        height: 750
        rows: gamecontroller.rows
        columns: gamecontroller.columns
        spacing: 1
        anchors.centerIn: parent

        Repeater {
            model: gameGrid.rows * gamecontroller.columns

            Rectangle {
                id: cell
                property bool alive: false
                width: (gameGrid.width - (gameGrid.columns - 1)
                        * gameGrid.spacing) / gameGrid.columns
                height: (gameGrid.height - (gameGrid.rows - 1) * gameGrid.spacing) / gameGrid.rows
                color: alive ? "#1db954" : "#404040"
                border.color: "#2c2c2c"
                border.width: 1
                radius: 2

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                }

                Connections {
                    target: mouseArea
                    function onClicked() {
                        gamecontroller.toggleCell(index)
                    }
                }

                Connections {
                    target: gamecontroller
                    function onCellChanged(idx, state) {
                        if (idx === index) {
                            alive = state
                        }
                    }
                }
            }
        }
    }
}
