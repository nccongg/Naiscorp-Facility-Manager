import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    width: 400
    height: 300
    visible: true
    title: "Naiscorp Facility Manager"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            id: helloText
            text: "Hello from Naiscorp Facility Manager!"
            font.pixelSize: 24
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            id: testButton
            text: "Click Me!"
            Layout.alignment: Qt.AlignHCenter
            width: 150
            height: 50
            
            background: Rectangle {
                color: testButton.pressed ? "#34495e" : "#3498db"
                radius: 5
                border.color: "#2980b9"
                border.width: 2
            }
            
            contentItem: Text {
                text: testButton.text
                font.pixelSize: 16
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: {
                helloText.text = "Button clicked! " + new Date().toLocaleTimeString()
                console.log("Button clicked at:", new Date().toLocaleTimeString())
            }
        }

        Text {
            id: statusText
            text: "Ready to use"
            font.pixelSize: 14
            color: "#7f8c8d"
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
