import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
  id: root
  width: 960; height: 600; visible: true
  title: "Naiscorp Facility Manager"

  StackView {
    id: stack
    anchors.fill: parent
    initialItem: "qrc:/Login.qml"
    
    // Handle navigation signals from current item
    Connections {
      target: stack.currentItem
      ignoreUnknownSignals: true
      
      function onSignupRequested() {
        console.log("Navigation: Login -> Signup")
        stack.push("qrc:/Signup.qml")
      }
      
      function onLoggedIn() {
        console.log("Navigation: Login -> Dashboard")
        stack.replace("qrc:/Dashboard.qml")
      }
      
      function onBackToLogin() {
        console.log("Navigation: Signup -> Login")
        stack.pop()
      }
      
      function onLogout() {
        console.log("Navigation: Dashboard -> Login")
        stack.replace("qrc:/Login.qml")
      }
    }
  }
}
