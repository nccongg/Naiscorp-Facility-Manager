import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
  signal backToLogin()
  
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
      text: "Create Account"
      font.pixelSize: 28
      font.bold: true
      color: "#2c3e50"
      Layout.alignment: Qt.AlignHCenter
      Layout.bottomMargin: 20
    }

    // Signup Form
    Rectangle {
      Layout.fillWidth: true
      height: 360
      color: "white"
      radius: 10
      border.color: "#dee2e6"
      border.width: 1

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 15

        Text {
          text: "Sign Up"
          font.pixelSize: 20
          font.bold: true
          color: "#495057"
          Layout.alignment: Qt.AlignHCenter
        }

        TextField {
          id: user
          placeholderText: "Username"
          Layout.fillWidth: true
          Layout.preferredHeight: 45
          font.pixelSize: 14
          background: Rectangle {
            color: "#f8f9fa"
            border.color: user.focus ? "#007bff" : "#ced4da"
            border.width: 2
            radius: 5
          }
        }

        TextField {
          id: email
          placeholderText: "Email"
          Layout.fillWidth: true
          Layout.preferredHeight: 45
          font.pixelSize: 14
          background: Rectangle {
            color: "#f8f9fa"
            border.color: email.focus ? "#007bff" : "#ced4da"
            border.width: 2
            radius: 5
          }
        }

        TextField {
          id: pass
          placeholderText: "Password"
          echoMode: TextInput.Password
          Layout.fillWidth: true
          Layout.preferredHeight: 45
          font.pixelSize: 14
          background: Rectangle {
            color: "#f8f9fa"
            border.color: pass.focus ? "#007bff" : "#ced4da"
            border.width: 2
            radius: 5
          }
        }

        Button {
          text: "Sign Up"
          Layout.fillWidth: true
          Layout.preferredHeight: 45
          font.pixelSize: 16
          font.bold: true
          
          background: Rectangle {
            color: parent.pressed ? "#218838" : (parent.hovered ? "#1e7e34" : "#28a745")
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
            status.text = "Creating account..."
            status.color = "#6c757d"
            // Call auth.signup() - nó sẽ emit signal signupSucceeded hoặc signupFailed
            auth.signup(user.text, email.text, pass.text)
          }
        }

        Button {
          text: "Back to Login"
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
          
          onClicked: {
            backToLogin()
          }
        }

        Label {
          id: status
          text: "Fill in your details"
          color: "#6c757d"
          font.pixelSize: 12
          Layout.alignment: Qt.AlignHCenter
          Layout.topMargin: 10
          
          Connections {
            target: auth
            function onSignupFailed(reason) { 
              status.text = reason
              status.color = "#dc3545"
            }
            function onSignupSucceeded() { 
              status.text = "Account created! Please login."
              status.color = "#28a745"
              // Auto navigate back to login after 2 seconds
              backTimer.start()
            }
          }
        }
      }
    }
  }
  
  // Timer for auto-navigation back to login
  Timer {
    id: backTimer
    interval: 2000 // 2 seconds
    running: false
    repeat: false
    onTriggered: backToLogin()
  }
}
