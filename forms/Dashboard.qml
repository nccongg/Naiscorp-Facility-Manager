import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
  anchors.fill: parent
  
  signal logout()

  Rectangle {
    anchors.fill: parent
    gradient: Gradient {
      GradientStop { position: 0.0; color: "#f8f9fa" }
      GradientStop { position: 1.0; color: "#e9ecef" }
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 20

    // Header
    Rectangle {
      Layout.fillWidth: true
      height: 80
      color: "white"
      radius: 10
      border.color: "#dee2e6"
      border.width: 1

      RowLayout {
        anchors.fill: parent
        anchors.margins: 20

        Text {
          text: "Naiscorp Facility Manager Dashboard"
          font.pixelSize: 24
          font.bold: true
          color: "#2c3e50"
          Layout.fillWidth: true
        }

        Button {
          text: "Logout"
          Layout.preferredWidth: 100
          Layout.preferredHeight: 40
          
          background: Rectangle {
            color: parent.pressed ? "#c82333" : (parent.hovered ? "#e0a800" : "#ffc107")
            radius: 5
          }
          
          contentItem: Text {
            text: parent.text
            color: "#212529"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
          }
          
          onClicked: {
            logout()
          }
        }
      }
    }

    // Main Content
    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 20

      // Sidebar
      Rectangle {
        Layout.preferredWidth: 250
        Layout.fillHeight: true
        color: "white"
        radius: 10
        border.color: "#dee2e6"
        border.width: 1

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 20
          spacing: 10

          Text {
            text: "Menu"
            font.pixelSize: 18
            font.bold: true
            color: "#495057"
            Layout.bottomMargin: 10
          }

          Button {
            text: "Assets"
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            
            background: Rectangle {
              color: parent.pressed ? "#0056b3" : (parent.hovered ? "#0069d9" : "#007bff")
              radius: 5
            }
            
            contentItem: Text {
              text: parent.text
              color: "white"
              horizontalAlignment: Text.AlignLeft
              verticalAlignment: Text.AlignVCenter
              leftPadding: 15
            }
            
            onClicked: {
              console.log("Assets clicked")
            }
          }

          Button {
            text: "Maintenance"
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            
            background: Rectangle {
              color: parent.pressed ? "#0056b3" : (parent.hovered ? "#0069d9" : "#007bff")
              radius: 5
            }
            
            contentItem: Text {
              text: parent.text
              color: "white"
              horizontalAlignment: Text.AlignLeft
              verticalAlignment: Text.AlignVCenter
              leftPadding: 15
            }
            
            onClicked: {
              console.log("Maintenance clicked")
            }
          }

          Button {
            text: "Reports"
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            
            background: Rectangle {
              color: parent.pressed ? "#0056b3" : (parent.hovered ? "#0069d9" : "#007bff")
              radius: 5
            }
            
            contentItem: Text {
              text: parent.text
              color: "white"
              horizontalAlignment: Text.AlignLeft
              verticalAlignment: Text.AlignVCenter
              leftPadding: 15
            }
            
            onClicked: {
              console.log("Reports clicked")
            }
          }

          Button {
            text: "Settings"
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            
            background: Rectangle {
              color: parent.pressed ? "#5a6268" : (parent.hovered ? "#6c757d" : "#6c757d")
              radius: 5
            }
            
            contentItem: Text {
              text: parent.text
              color: "white"
              horizontalAlignment: Text.AlignLeft
              verticalAlignment: Text.AlignVCenter
              leftPadding: 15
            }
            
            onClicked: {
              console.log("Settings clicked")
            }
          }

          Item {
            Layout.fillHeight: true
          }
        }
      }

      // Main Content Area
      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "white"
        radius: 10
        border.color: "#dee2e6"
        border.width: 1

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 30
          spacing: 20

          Text {
            text: "Welcome to Facility Manager"
            font.pixelSize: 24
            font.bold: true
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
          }

          Text {
            text: "System Status: Online"
            font.pixelSize: 16
            color: "#28a745"
            Layout.alignment: Qt.AlignHCenter
          }

          // Stats Cards
          GridLayout {
            columns: 2
            Layout.fillWidth: true
            Layout.topMargin: 30
            columnSpacing: 20
            rowSpacing: 20

            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: 100
              color: "#e3f2fd"
              radius: 8
              border.color: "#2196f3"
              border.width: 2

              ColumnLayout {
                anchors.centerIn: parent
                spacing: 5
                
                Text {
                  text: "Total Assets"
                  font.pixelSize: 14
                  color: "#1976d2"
                  Layout.alignment: Qt.AlignHCenter
                }
                Text {
                  text: "156"
                  font.pixelSize: 28
                  font.bold: true
                  color: "#1565c0"
                  Layout.alignment: Qt.AlignHCenter
                }
              }
            }

            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: 100
              color: "#e8f5e8"
              radius: 8
              border.color: "#4caf50"
              border.width: 2

              ColumnLayout {
                anchors.centerIn: parent
                spacing: 5
                
                Text {
                  text: "Active"
                  font.pixelSize: 14
                  color: "#388e3c"
                  Layout.alignment: Qt.AlignHCenter
                }
                Text {
                  text: "142"
                  font.pixelSize: 28
                  font.bold: true
                  color: "#2e7d32"
                  Layout.alignment: Qt.AlignHCenter
                }
              }
            }

            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: 100
              color: "#fff3e0"
              radius: 8
              border.color: "#ff9800"
              border.width: 2

              ColumnLayout {
                anchors.centerIn: parent
                spacing: 5
                
                Text {
                  text: "Maintenance"
                  font.pixelSize: 14
                  color: "#f57c00"
                  Layout.alignment: Qt.AlignHCenter
                }
                Text {
                  text: "12"
                  font.pixelSize: 28
                  font.bold: true
                  color: "#ef6c00"
                  Layout.alignment: Qt.AlignHCenter
                }
              }
            }

            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: 100
              color: "#ffebee"
              radius: 8
              border.color: "#f44336"
              border.width: 2

              ColumnLayout {
                anchors.centerIn: parent
                spacing: 5
                
                Text {
                  text: "Issues"
                  font.pixelSize: 14
                  color: "#d32f2f"
                  Layout.alignment: Qt.AlignHCenter
                }
                Text {
                  text: "2"
                  font.pixelSize: 28
                  font.bold: true
                  color: "#c62828"
                  Layout.alignment: Qt.AlignHCenter
                }
              }
            }
          }

          Item {
            Layout.fillHeight: true
          }
        }
      }
    }
  }
}
