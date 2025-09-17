import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
  signal signupRequested()
  signal loggedIn()

  Rectangle {
    anchors.fill: parent
    gradient: Gradient {
      GradientStop { position: 0.0; color: "#f8f9fa" }
      GradientStop { position: 1.0; color: "#e9ecef" }
    }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 20
    width: 320

    // Logo/Title
    Text {
      text: "Naiscorp Facility Manager"
      font.pixelSize: 28
      font.bold: true
      color: "#2c3e50"
      Layout.alignment: Qt.AlignHCenter
      Layout.bottomMargin: 20
    }

    // Login Form
    Rectangle {
      Layout.fillWidth: true
      height: 280
      color: "white"
      radius: 10
      border.color: "#dee2e6"
      border.width: 1

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 15

        Text {
          text: "Sign In"
          font.pixelSize: 20
          font.bold: true
          color: "#495057"
          Layout.alignment: Qt.AlignHCenter
        }

        TextField {
          id: username
          placeholderText: "Username"
          Layout.fillWidth: true
          Layout.preferredHeight: 45
          font.pixelSize: 14
          background: Rectangle {
            color: "#f8f9fa"
            border.color: username.focus ? "#007bff" : "#ced4da"
            border.width: 2
            radius: 5
          }
        }

        TextField {
          id: password
          placeholderText: "Password"
          echoMode: TextInput.Password
          Layout.fillWidth: true
          Layout.preferredHeight: 45
          font.pixelSize: 14
          background: Rectangle {
            color: "#f8f9fa"
            border.color: password.focus ? "#007bff" : "#ced4da"
            border.width: 2
            radius: 5
          }
        }

        Button {
          text: "Login"
          Layout.fillWidth: true
          Layout.preferredHeight: 45
          font.pixelSize: 16
          font.bold: true
          
          background: Rectangle {
            color: parent.pressed ? "#0056b3" : (parent.hovered ? "#0069d9" : "#007bff")
            radius: 5
          }
          
          contentItem: Text {
            text: parent.text
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font: parent.font
          }
          
          onClicked: {
            status.text = "Logging in..."
            status.color = "#6c757d"
            // Call auth.login() - nó sẽ emit signal loginSucceeded hoặc loginFailed
            auth.login(username.text, password.text)
          }
        }

        Button {
          text: "Create Account"
          Layout.fillWidth: true
          
          Layout.preferredHeight: 35
          font.pixelSize: 14
          
          background: Rectangle {
            color: "transparent"
            border.color: "#6c757d"
            border.width: 1
            radius: 5
          }
          
          contentItem: Text {
            text: parent.text
            color: "#6c757d"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font: parent.font
          }
          
          onClicked: signupRequested()
        }

        Label {
          id: status
          text: "Enter admin/admin or test/test"
          color: "#6c757d"
          font.pixelSize: 12
          Layout.alignment: Qt.AlignHCenter
          Layout.topMargin: 10
          
          Connections {
            target: auth
            function onLoginFailed(reason) { 
              status.text = reason
              status.color = "#dc3545"
            }
            function onLoginSucceeded() {
              status.text = "Login successful!"
              status.color = "#28a745"
              // Navigate to dashboard
              loggedIn()
            }
          }
        }
      }
    }
  }
}
